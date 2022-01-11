module DateValidator
  def validate_from_to(from:, to:)
    @from = from
    @to = to
    return if @to.blank? || @from.blank?
    return if @to > @from

    flash.now[:notice] = 'From Date Should Be Less Than To Date'
    @from = @to
  end
end
