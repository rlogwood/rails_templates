module ApplicationHelper

  def link_to_add_fields(name, form, association)
    ## create a new object from the association
    new_object = form.object.send(association).klass.new

    ## just create or take the id from the new created object
    id = new_object.object_id

    ## create the fields from
    fields = form.fields_for(association, new_object, child_index: id) do |builder|
      render("fields/#{association.to_s.singularize}_fields", form: builder)
    end

    ## pass down the link to the fields form
    link_to(name, '#', class: 'add_fields', data: { id: id, fields: fields.gsub("\n","") } )
  end

end
