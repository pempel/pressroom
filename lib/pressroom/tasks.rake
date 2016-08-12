require "pressroom"

namespace :pressroom do
  desc "Release the app"
  task :release, [:env, :sha, :tag] do |t, args|
    env, sha, tag = args[:env], args[:sha], args[:tag]
    release = Pressroom::Release.create(env: env, sha: sha, tag: tag)
    release.send_notification_to_slack
  end
end
