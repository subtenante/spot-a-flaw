class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.string :title
      t.text :content
      t.text :origin
      t.string :url

      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
