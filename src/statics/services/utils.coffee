module = angular.module 'jt.utils', []




module.factory 'utils', ['$http', '$rootScope', ($http, $rootScope) -> 

  utils =
    now : Date.now || ->
      new Date().getTime()
    throttle : (func, wait, options) ->
      context = undefined
      args = undefined
      result = undefined
      timeout = null
      previous = 0
      options = {}  unless options
      later = ->
        previous = if options.leading is false then 0 else utils.now()
        timeout = null
        result = func.apply(context, args)
        context = args = null  unless timeout
        return

      ->
        now = utils.now()
        previous = now  if not previous and options.leading is false
        remaining = wait - (now - previous)
        context = @
        args = arguments
        if remaining <= 0 or remaining > wait
          clearTimeout timeout
          timeout = null
          previous = now
          result = func.apply(context, args)
          context = args = null  unless timeout
        else timeout = setTimeout(later, remaining)  if not timeout and options.trailing isnt false
        result
    debounce : (func, wait, immediate) ->
      timeout = undefined
      args = undefined
      context = undefined
      timestamp = undefined
      result = undefined
      later = ->
        last = utils.now() - timestamp
        if last < wait and last > 0
          timeout = setTimeout(later, wait - last)
        else
          timeout = null
          unless immediate
            result = func.apply(context, args)
            context = args = null  unless timeout
        return

      ->
        context = @
        args = arguments
        timestamp = utils.now()
        callNow = immediate and not timeout
        timeout = setTimeout(later, wait)  unless timeout
        if callNow
          result = func.apply(context, args)
          context = args = null
        result
    uuid : ->
      str = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        if c == 'x'
          v = r
        else
          v = r & 0x3|0x8

        v.toString 16
      str
  utils
]
