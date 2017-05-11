class AddCommentNumToPost < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :comment_num, :integer, :default => 0
  end
end
