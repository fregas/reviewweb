

class AddLineNumberCol < Sequel::Migration

  def up
    alter_table :DomainsProcessed do
      add_column :line_number, Integer
    end
  end
  
end
