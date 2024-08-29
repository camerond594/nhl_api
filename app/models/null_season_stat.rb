class NullSeasonStat
  def method_missing(method_name, *arguments, &block)
    nil
  end
end