require 'securerandom'
module Jekyll
  class ReplaceContent < Converter
    safe true
    priority :low

    DEFAULT_PLACEHOLDER = ""  # 默认占位符

    def matches(ext)
      ext =~ /^\.md$/i
    end

    def output_ext(ext)
      ".html"
    end

    def convert(content)
      in_tab_group = false
      current_tabs = []
      current_contents = []
      tab_content = ""
      final_content = []

      content.split("\n").each do |line|
        if match = line.match(/====\[(.*?)\]====/)
          tab_title = match[1].strip

          if tab_title == 'tabend'
            current_contents << (tab_content.strip.empty? ? DEFAULT_PLACEHOLDER : tab_content.strip)
            final_content << generate_tab_group(current_tabs, current_contents)
            current_tabs = []
            current_contents = []
            tab_content = ""
            in_tab_group = false
            next
          end

          if in_tab_group
            current_contents << (tab_content.strip.empty? ? DEFAULT_PLACEHOLDER : tab_content.strip)
            tab_content = ""
          end

          current_tabs << tab_title
          in_tab_group = true
        elsif in_tab_group
          tab_content += line + "\n"
        else
          final_content << line
        end
      end

      unless tab_content.strip.empty? || !in_tab_group
        current_contents << tab_content.strip
        final_content << generate_tab_group(current_tabs, current_contents) if in_tab_group
      end

      final_content.join("\n")
    end

    def generate_tab_group(tabs, contents)
      tab_group_id = "tab-group-#{SecureRandom.hex}" # 生成唯一的 tab 组 id
      nav_tabs = []
      tab_contents = []

      tabs.each_with_index do |title, index|
        active_class = index.zero? ? ' active' : ''
        fade_class = index.zero? ? ' show active' : ' fade'

        # 替换标题中的空格为连字符
        title_id = title.downcase.gsub(' ', '-')

        nav_tabs << %(
          <li class="nav-item mx-4 my-2" role="presentation">
              <button class="nav-link hvr-bubble-bottom text-reset#{active_class}" id="#{title_id}-tab" data-bs-toggle="tab" data-bs-target="##{title_id}-tab-pane" type="button" role="tab" aria-controls="#{title_id}-tab-pane" aria-selected="#{index.zero?}">#{title}</button>
          </li>
        )

        tab_contents << %(
          <div class="tab-pane fade#{fade_class}" id="#{title_id}-tab-pane" role="tabpanel" aria-labelledby="#{title_id}-tab">#{contents[index]}</div>
        )
      end

      %(
        <ul class="nav nav-pills nav-fill flex-column flex-sm-row mt-5 mb-4" id="#{tab_group_id}" role="tablist">
          #{nav_tabs.join}
        </ul>
        <div class="tab-content" id="#{tab_group_id}-content">
          #{tab_contents.join}
        </div>
      )
    end
  end
end
