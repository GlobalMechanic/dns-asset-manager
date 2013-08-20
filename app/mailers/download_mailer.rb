class DownloadMailer < ActionMailer::Base
  def download_ready(email, episode, upload_name)
    mail(
      from: "studio@globalmechanic.com",
      to: email,
      subject: "#{episode.title} Episode Archive",
      body: "Your episode archive is ready, click to download:<br><br>https://asset-manager.s3.amazonaws.com/#{upload_name}",
      content_type: "text/html",
    )
  end
end
