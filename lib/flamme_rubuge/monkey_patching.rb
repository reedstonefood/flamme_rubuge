class Array # :nodoc:
  def delete_first(item)
    delete_at(index(item) || length)
  end

  def reverse_each_with_index(&block)
    (0...length).reverse_each do |i|
      block.call self[i], i
    end
  end
end
