library(tidyverse)
library(rvest)

url <- "https://en.wikipedia.org/"
html <- read_html(url)

### PART 1 ###
logo <- html_element(html, xpath = "/html/body/div[2]/div/div[3]/main/div[3]
                     /div[3]/div[1]/div[2]/div[2]/div[1]/div[1]/div/span/a/img")

html_attrs(logo)

### PART 2 ###
featured_article <- html_element(html, xpath = "/html/body/div[2]/div/div[3]
                                 /main/div[3]/div[3]/div[1]/div[2]
                                 /div[1]/div[1]")

print(html_text(featured_article))

featured_article_links <- html_elements(featured_article, "a")
print(featured_article_links)

hrefs <- featured_article_links %>%
  html_attr("href")

titles <- featured_article_links %>%
  html_attr("title")

featured_article_links <- data.frame(
  href = hrefs,
  title = titles
)

View(featured_article_links)

### PART 3 ###
first_link <- hrefs[1]

first_link_url <- paste0("https://en.wikipedia.org", first_link)

html2 <- read_html(first_link_url)

h2_headers <- html2 %>%
  html_elements("h2") %>%
  html_text()

h2_headers

### BONUS TASK ###
featured_article_h2 = data.frame(url=character(0), page_title=character(0), link=character(0),
                header=character(0))
  
for (i in 1:nrow(featured_article_links)) {
  temp_link = hrefs[i]
  temp_url = paste0("https://en.wikipedia.org", temp_link)
  temp_html = read_html(temp_url)
  
  h2_temp_title <- temp_html %>%
    html_element("h1") %>%
    html_text()
  
  h2_temp_headers <- temp_html %>%
    html_elements("h2") %>%
    html_text()
  
  featured_article_h2 %>%
    add_row(url = temp_url, page_title = h2_temp_title, link = temp_link,
            header = h2_temp_headers)
}

View(featured_article_h2)
