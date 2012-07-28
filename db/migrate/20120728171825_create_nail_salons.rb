class CreateNailSalons < ActiveRecord::Migration
  def change
    create_table :nail_salons do |t|
      t.string :title
      t.string :phone_num
      t.string :address
      t.string :zip
      t.string :state
      t.string :region
      t.string :uuid
      t.string :url
      t.string :category

      t.timestamps
    end
  end
end
