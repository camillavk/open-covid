class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :short_description, limit: 140
      t.string :url
      t.text :description
      t.string :email
 
      t.timestamps
    end

    create_table :tags do |t|
      t.string :name
    end

    create_table :projects_tags, id: false do |t|
      t.belongs_to :project
      t.belongs_to :tag
    end
  end
end
