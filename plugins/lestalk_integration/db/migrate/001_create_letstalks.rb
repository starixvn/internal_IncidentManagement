class CreateLetstalks < ActiveRecord::Migration
  def change
    create_table :letstalks do |t|

      t.boolean :ischeck

      t.string :comment


    end

  end
end
