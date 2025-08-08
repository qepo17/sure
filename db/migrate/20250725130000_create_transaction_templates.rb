class CreateTransactionTemplates < ActiveRecord::Migration[7.2]
  def change
    create_table :transaction_templates, id: :uuid do |t|
      t.string :name, null: false
      t.references :family, null: false, type: :uuid, foreign_key: { on_delete: :cascade }
      t.references :account, type: :uuid, foreign_key: { on_delete: :cascade }
      t.decimal :amount, precision: 19, scale: 4
      t.string :currency, default: "USD", null: false
      t.string :nature, default: "outflow", null: false
      t.references :category, type: :uuid, foreign_key: { to_table: :categories, on_delete: :nullify }
      t.text :notes
      t.jsonb :tag_ids, default: []

      t.timestamps
    end
  end
end
