{
	for(; count; --count) {
		<%= self.kernel %>
		<% (1 .. self.arity).each do |i| %>
		input_<%= i %> += input_<%= i %>_stride / sizeof(*input_<%= i %>);<% end %>
		counter += counter_stride;
	}
}