module ApplicationHelper
  def nav_active?(path)
    current_page?(path) ? "bg-indigo-50 text-indigo-700" : "text-slate-600 hover:bg-slate-100 hover:text-slate-900"
  end

  def status_badge(status)
    colors = {
      "published" => "bg-emerald-100 text-emerald-800",
      "draft" => "bg-slate-100 text-slate-700",
      "closed" => "bg-rose-100 text-rose-800",
      "pending" => "bg-amber-100 text-amber-800",
      "paid" => "bg-emerald-100 text-emerald-800",
      "delivered" => "bg-emerald-100 text-emerald-800",
      "cancelled" => "bg-rose-100 text-rose-800",
      "in_progress" => "bg-blue-100 text-blue-800",
      "completed" => "bg-emerald-100 text-emerald-800",
      "planning" => "bg-slate-100 text-slate-700",
      "on_hold" => "bg-amber-100 text-amber-800",
      "todo" => "bg-slate-100 text-slate-700",
      "done" => "bg-emerald-100 text-emerald-800",
      "hired" => "bg-emerald-100 text-emerald-800",
      "rejected" => "bg-rose-100 text-rose-800",
      "shortlisted" => "bg-blue-100 text-blue-800",
      "reviewed" => "bg-indigo-100 text-indigo-800"
    }
    color = colors[status.to_s] || "bg-slate-100 text-slate-700"
    content_tag(:span, status.to_s.titleize, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{color}")
  end

  def priority_badge(priority)
    colors = {
      "low" => "bg-slate-100 text-slate-700",
      "medium" => "bg-blue-100 text-blue-800",
      "high" => "bg-amber-100 text-amber-800",
      "urgent" => "bg-rose-100 text-rose-800"
    }
    color = colors[priority.to_s] || "bg-slate-100 text-slate-700"
    content_tag :span, priority.to_s.titleize, class: "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium #{color}"
  end

  # Returns a safe, validated URL for external links.
  # The model validates the format, and this helper ensures only http/https schemes pass through.
  def safe_external_url(url)
    return nil if url.blank?

    uri = URI.parse(url)
    return url if %w[http https].include?(uri.scheme)

    nil
  rescue URI::InvalidURIError
    nil
  end
end
