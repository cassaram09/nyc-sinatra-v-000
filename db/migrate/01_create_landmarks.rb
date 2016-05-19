class CreateLandmarks < ActiveRecord::Migration
  def change
    create_table :landmarks do |t|
      t.string :name
      t.integer :year_completed
      t.belongs_to :figure, index: true
    end
  end
end
