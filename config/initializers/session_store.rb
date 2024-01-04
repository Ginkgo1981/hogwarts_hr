if Rails.env.test?
  Rails.application.config.session_store :cache_store, key: "_golden_legend_test_session"
else
  Rails.application.config.session_store :cache_store, key: "_golden_legend_session", path: "/", expire_after: ENV["SESSION_EXPIRE"].to_i.minutes, httponly: true

  if Rails.env.production? || Rails.env.staging?
    Rails.application.config.session_store :cache_store, key: "_golden_legend_session", path: "/", expire_after: ENV["SESSION_EXPIRE"].to_i.minutes, httponly: true, secure: true
  end
end
