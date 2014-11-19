Instagram.configure do |config|
  config.client_id = "073d34c417fb43479fce2bc1cb7f2c2f"
  config.client_secret = "313fedd6c4b44a52900760de5e42a7eb"
end

class String
  def similarity_to(other_string)
    str1 = self
    str2 = other_string
    str1.downcase!
    pairs1 = (0..str1.length-2).collect {|i| str1[i,2]}.reject {
      |pair| pair.include? " "}
    str2.downcase!
    pairs2 = (0..str2.length-2).collect {|i| str2[i,2]}.reject {
      |pair| pair.include? " "}
    union = pairs1.size + pairs2.size
    intersection = 0
    pairs1.each do |p1|
      0.upto(pairs2.size-1) do |i|
        if p1 == pairs2[i]
          intersection += 1
          pairs2.slice!(i)
          break
        end
      end
    end
    (2.0 * intersection) / union
  end
end