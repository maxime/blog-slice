class BlogSlice::CommentMailer < Merb::MailController
  controller_for_slice BlogSlice, :templates_for => :mailer, :path => "views"
  
  def notify
    @comment = params[:comment]
    @post = params[:post]
    render_mail :layout => nil
  end
end