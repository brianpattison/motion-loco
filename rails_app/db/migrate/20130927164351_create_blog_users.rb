class CreateBlogUsers < ActiveRecord::Migration
  def change
    create_table :blog_users do |t|
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
