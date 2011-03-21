{
	for(; count; --count) {
		<%= self.kernel %>
		
		output += output_stride / sizeof(*output);<% (1 .. self.arity).each do |i| %>
		input_<%= i %> += input_<%= i %>_stride / sizeof(*input_<%= i %>);<% end %>
	}
}