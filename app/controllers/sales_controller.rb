require 'csv'
require 'axlsx'
require 'stringio'

class SalesController < ApplicationController
  def new
    @sale = Sale.new
  end

  def create
    file = params[:file]

    if file.present?
      data = File.read(file.tempfile).split("\n").map { |line| line.split("\t") }

      total_income = 0
      data[1..-1].each do |row| # Ignora a linha de cabeçalho
        purchaser_name, item_description, item_price, purchase_count, merchant_address, merchant_name = row

        # Remover R$ da descrição e converter para float
        item_description.gsub!(/R\$?\s*/, '')

        # Extrair o valor numérico da descrição, se houver
        extracted_price = item_description.scan(/[\d,]+/).first
        extracted_price = extracted_price.tr(',', '.').to_f if extracted_price # Converte para float e substitui vírgula por ponto

        # Converte item_price para float e verifica se já foi fornecido
        item_price = item_price.to_f

        # Se a descrição contém um preço e o preço não foi fornecido, usar o preço extraído
        item_price = extracted_price if extracted_price && item_price.zero?

        # Se a descrição contém um preço, remova-o da descrição
        item_description.gsub!(/[\d,]+/, '')

        # Debug: Imprimir os dados que estão sendo enviados
        puts "Creating Sale: #{purchaser_name}, #{item_description}, #{item_price}, #{purchase_count}, #{merchant_address}, #{merchant_name}"

        # Use create! para verificar se há erros
        begin
          Sale.create!(
            purchaser_name: purchaser_name.strip, # Remove espaços em branco
            item_description: item_description.strip, # Remove espaços em branco
            item_price: item_price,
            purchase_count: purchase_count.to_i,
            merchant_address: merchant_address.strip, # Remove espaços em branco
            merchant_name: merchant_name.strip # Remove espaços em branco
          )

          total_income += item_price * purchase_count.to_i
        rescue ActiveRecord::RecordInvalid => e
          puts "Erro ao criar venda: #{e.message}"
          flash[:alert] = "Erro ao processar a linha: #{row.inspect}. #{e.message}"
        end
      end

      flash[:notice] = "Upload feito com sucesso!"
      redirect_to sales_path
    else
      redirect_to new_sale_path, alert: "Por favor, envie um arquivo."
    end
  end

  def index
    @sales = Sale.all
    @total_income = @sales.sum("item_price * purchase_count")
  end

  def edit
    @sale = Sale.find(params[:id])
  end

  def update
    @sale = Sale.find(params[:id])
    if @sale.update(sale_params)
      redirect_to sales_path, notice: 'Venda atualizada com sucesso.'
    else
      render :edit
    end
  end

  def destroy
    @sale = Sale.find(params[:id])
    @sale.destroy
    redirect_to sales_path, notice: 'Venda excluída com sucesso.'
  end

  def destroy_all
    Sale.delete_all
    redirect_to sales_path, notice: 'Todas as vendas foram excluídas com sucesso.'
  end

  def export
    @sales = Sale.all
    respond_to do |format|
      format.csv { send_data to_csv(@sales), filename: "vendas-#{Date.today}.csv" }
      format.xlsx do
        io = StringIO.new
        to_xlsx(@sales, io)
        io.rewind
        send_data io.string, filename: "vendas-#{Date.today}.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      end
    end
  end

  private

  def sale_params
    params.require(:sale).permit(:purchaser_name, :item_description, :item_price, :purchase_count, :merchant_address, :merchant_name)
  end

  def to_csv(sales)
    CSV.generate(col_sep: ";", headers: true) do |csv|
      csv << ["Nome do Comprador", "Descrição do Item", "Preço do Item", "Quantidade Comprada", "Endereço do Comerciante", "Nome do Comerciante"]
      
      sales.each do |sale|
        csv << [sale.purchaser_name, sale.item_description, sale.item_price, sale.purchase_count, sale.merchant_address, sale.merchant_name]
      end
    end
  end

  def to_xlsx(sales, io)
    package = Axlsx::Package.new
    package.workbook.add_worksheet(name: "Vendas") do |sheet|
      sheet.add_row ["Nome do Comprador", "Descrição do Item", "Preço do Item", "Quantidade Comprada", "Endereço do Comerciante", "Nome do Comerciante"]
      
      sales.each do |sale|
        sheet.add_row [sale.purchaser_name, sale.item_description, sale.item_price, sale.purchase_count, sale.merchant_address, sale.merchant_name]
      end
    end

    io.write package.to_stream.read
  end
end
