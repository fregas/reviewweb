class CreateDomainsProcessed < Sequel::Migration
  def up
    create_table :DomainsProcessed do
      primary_key :id, :auto_increment => true
      String :domain_name, :size => 255
    end
  end
  
  def down
    # You can use raw SQL if you need to
    self << 'DROP TABLE DomainsProcessed'
  end
end


