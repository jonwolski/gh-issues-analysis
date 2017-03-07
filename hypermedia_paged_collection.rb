class HypermediaPagedCollection
  include Enumerable

  def initialize(response)
    # not threadsafe
    @response = response
  end

  def each(&block)
    response = @response
    response.data.each do |member|
      block.call(member)
    end
    while response.rels[:next]
      response = response.rels[:next].get
      response.data.each do |member|
        block.call(member)
      end
    end
  end
end
