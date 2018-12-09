# library(telegram.bot)
# library(R6)
# library(beepr)
#

Notifier <- R6::R6Class("Notifier", public = list(
  env_name = NA,
  bot_token = NULL,
  bot = NULL,
  chat_id = NULL,
  telegram_bot = F,

  initialize = function(env_name = NA){
    stopifnot(is.character(env_name), length(env_name) == 1)
    self$env_name <- env_name
    bot_name <- 'rnotifbot'
    self$bot_token <-  telegram.bot::bot_token(bot_name)
    self$chat_id <- Sys.getenv(paste0("R_TELEGRAM_BOT_", bot_name, "_CHAT_ID"))
    if(nchar(self$bot_token) == 0 || nchar(self$chat_id) == 0){
      self$telegram_bot = F
    } else{
      self$telegram_bot = T
    }
    if(self$telegram_bot){
      self$bot <- telegram.bot::Bot(token = self$bot_token)
    }

  },
  notify = function(message){
    if(self$telegram_bot){
      message <- sprintf("%s - %s - %s", self$env_name, date(), message)
      self$bot$sendMessage(text=message, chat_id=self$chat_id)
    }else{
      beepr::beep()
    }
  }
)
)

# n <- Notifier$new(env_name = "Test")
# n$env_name
# n$bot_token
# n$chat_id
# n$notify("Test")
