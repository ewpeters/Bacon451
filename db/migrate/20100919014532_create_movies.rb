class CreateMovies < ActiveRecord::Migration
  def self.up
    create_table :movies do |t|
      t.column :name, :string
      t.timestamps
    end
  end

  def self.down
    drop_table :movies
  end
end
