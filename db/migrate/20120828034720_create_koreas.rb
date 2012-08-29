class CreateKoreas < ActiveRecord::Migration
  def change
    create_table :koreas do |t|
      t.string :title
      t.text :description
      t.string :phone_num
      t.string :fax
      t.string :website
      t.string :email
      t.string :address
      t.string :street
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :level
      t.string :uuid

      t.timestamps
    end
  end
end
