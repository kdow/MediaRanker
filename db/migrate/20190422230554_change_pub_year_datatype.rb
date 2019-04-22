class ChangePubYearDatatype < ActiveRecord::Migration[5.2]
  def change
    change_column :works, :publication_year, "integer USING CAST(publication_year AS integer)"
  end
end
