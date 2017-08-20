class ModelPresenter
  attr_reader :object, :view_context
  delegate :raw, to: :view_context # rawメソッドはview_contextに移譲

  def initialize(object, view_context)
    @object = object
    @view_context = view_context
  end
end
