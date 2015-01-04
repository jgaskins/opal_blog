require 'clearwater/model'
require 'time'

class Article < Clearwater::Model
  # attr_reader :id, :created_at
  # attr_accessor :title, :body
  attributes :id, :title, :body, :created_at

  def initialize attrs={}
    super

    @created_at ||= Time.parse(attrs[:created_at]) || Time.now
  end
end
