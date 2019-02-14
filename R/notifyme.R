# library(telegram.bot)
# library(R6)
# library(beepr)
#

Notifier <- R6::R6Class("Notifier", public = list(
  env_name = NA,

  initialize = function(env_name = NA, key = NA){
    library(RPushbullet)
    stopifnot(is.character(env_name), length(env_name) == 1)
    self$env_name <- env_name
    if(!file.exists("~/.rpushbullet.json")){
      if(!is.na(key)){
        getDevices()
      }else{
        stop("Key must be given if the file ~/.rpushbullet.json doesn't exist")
      }
    }
  },
  getDevices = function(key){
    h <- curl::new_handle()
    curl::handle_setheaders(h, "Access-Token" =  key)
    req <- curl::curl_fetch_memory("https://api.pushbullet.com/v2/devices", handle = h)
    data <- jsonlite::fromJSON(rawToChar(req$content))
    devices <- data$devices
    devices <- dplyr::filter(devices, active == TRUE & pushable == TRUE)
    write(jsonlite::toJSON(list(key=unbox("o.rDn8jnhhh1BreTpn7pQnl3eLnz7VHi3k"), devices=devices$iden, names=devices$nickname), pretty=TRUE), file = "~/.rpushbullet.json")
    detach("package:RPushbullet", unload=TRUE)
    library(RPushbullet)
    pbPost("note", title="Success", body="Devices successfully found.")
  },
  notify = function(message){
      message <- sprintf("%s\n%s", date(), message)
      pbPost("note", title=self$env_name, body=message)
  }
)
)

n <- Notifier$new(env_name = "Test")
# n$getDevices("o.rDn8jnhhh1BreTpn7pQnl3eLnz7VHi3k")
n$notify("Test")
