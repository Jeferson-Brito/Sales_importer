import React from 'react';

const SalesList = ({ sales }) => {
  return (
    <div>
      <h1>Lista de Vendas</h1>
      <table style={{ margin: 'auto', borderCollapse: 'collapse' }}>
        <thead>
          <tr>
            <th>Nome do Comprador</th>
            <th>Descrição do Item</th>
            <th>Preço do Item</th>
            <th>Quantidade Comprada</th>
            <th>Endereço do Comerciante</th>
            <th>Nome do Comerciante</th>
          </tr>
        </thead>
        <tbody>
          {sales.map((sale) => (
            <tr key={sale.id}>
              <td>{sale.purchaser_name}</td>
              <td>{sale.item_description}</td>
              <td>{sale.item_price}</td>
              <td>{sale.purchase_count}</td>
              <td>{sale.merchant_address}</td>
              <td>{sale.merchant_name}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default SalesList;
