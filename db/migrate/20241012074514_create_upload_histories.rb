class CreateUploadHistories < ActiveRecord::Migration[7.2]
  def change
    create_table :upload_histories do |t|
      t.string :file_name
      t.datetime :uploaded_at

      t.timestamps
    end
  end
end
