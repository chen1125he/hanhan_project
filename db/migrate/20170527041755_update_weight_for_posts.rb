class UpdateWeightForPosts < ActiveRecord::Migration[5.0]
  def change
    Post.all.each do |post|
      next if (post.comment_num  + post.good_num + post.read_num) <= 0
      weight = (post.comment_num * 0.5 + post.good_num * 0.3 + post.read_num * 0.2)/(post.comment_num  + post.good_num + post.read_num)
      post.update_attribute(:weight, weight)
    end
  end
end
