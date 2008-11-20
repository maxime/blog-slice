// Size Field Javascript Functions
// Mainly used for converting a size with units to the size in bytes.

function initialize_size_field(id) {
  $("#"+id+"_converted").bind('change', function() { update_size_field_value(id) });
  $("#"+id+"_unit").bind('change', function() { update_size_field_value(id) });
}

function update_size_field_value(id) {
  var converted_value = $("#"+id+"_converted").val();
  var unit = $("#"+id+"_unit").val();
  //alert("changed to "+converted_value+" "+unit);  
  var hidden_field = $("#"+id);
  if (unit=="B") { hidden_field.val(converted_value); }
  if (unit=="KB") { hidden_field.val(converted_value * 1024); }
  if (unit=="MB") { hidden_field.val(converted_value * 1024 * 1024); }
  if (unit=="GB") { hidden_field.val(converted_value * 1024 * 1024 * 1024); }
  if (unit=="TB") { hidden_field.val(converted_value * 1024 * 1024 * 1024 * 1024); }  
}