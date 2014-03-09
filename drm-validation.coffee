###############################################################################
# Client-side form validation
###############################################################################

( ($) ->

    drmForms = {

        config: {
            speed: 300
        }

        init: (config) ->
            $.extend @.config, config
            body = $ 'body'

            body.on 'click', ':disabled', (e) ->
                e.preventDefault()

            body.on 'keyup', '.drm-valid-integer', @validateInteger
            body.on 'keyup', '.drm-valid-number', @validateNumber
            body.on 'keyup', '.drm-valid-url', @validateURL
            body.on 'keyup', '.drm-valid-phone', @validatePhone
            body.on 'keyup', '.drm-valid-email', @validateEmail
            body.on 'keyup', '.drm-valid-full-name', @validateFullName
            body.on 'keyup', '.drm-valid-alpha', @validateAlpha
            body.on 'keyup', '.drm-valid-alphanum', @validateAlphaNum
            body.on 'keyup', '.drm-valid-alphadash', @validateAlphaNumDash
            body.on 'keyup', '.drm-valid-alpha-num-underscore', @validateAlphaNumUnderscore
            body.on 'keyup', '.drm-valid-no-spaces', @validateNoSpaces
            body.on 'keyup', '.drm-valid-no-tags', @validateNoTags
            body.on 'keyup', '[required]', @validateRequired
            body.on 'keyup', ':input[data-max-value]:not([data-min-value])', @validateMaxValue
            body.on 'keyup', ':input[data-min-value]:not([data-max-value])', @validateMinValue
            body.on 'keyup', ':input[data-max-length]:not([data-min-length])', @validateMaxLength
            body.on 'keyup', ':input[data-min-length]:not([data-max-length])', @validateMinLength
            body.on 'keyup', ':input[data-min-value][data-max-value]', @validateBetweenValue
            body.on 'keyup', ':input[data-min-length][data-max-length]', @validateBetweenLength
            body.on 'keyup', ':input', @trackLength
            body.on 'blur', ':input:not([required])', @validateEmpty

        success: ->
            that = $ @
            drmForms.removeValidationClass.call that
            that.addClass 'drm-form-success'

        warning: ->
            that = $ @
            drmForms.removeValidationClass.call that
            that.addClass 'drm-form-warning'

        danger: ->
            that = $ @
            drmForms.removeValidationClass.call that
            that.addClass 'drm-form-danger'

        trackLength: ->
            that = $ @
            value = $.trim that.val()
            length = value.length
            lengthNotice = $ ".form-length-notice"
            createMessage = (length) ->
                message = if length == 1 then "#{length} character" else "#{length} characters"
                return message

            if lengthNotice.length == 0
                message = createMessage(length)
                lengthNotice = $ '<p></p>', {
                    text: message
                    class: 'form-length-notice'
                }
                
                lengthNotice.hide().insertAfter(that).show()
            else if length == 0
                lengthNotice.remove()
            else
                message = createMessage(length)
                lengthNotice.text message

        issueNotice: (status, message) ->
            that = $ @
            notice = $ ".form-#{status}-notice:contains(#{message})"
            
            if notice.length == 0
                notice = $ '<p></p>', {
                    text: message,
                    class: "form-#{status}-notice"
                }
                
                notice.hide().insertAfter(that).slideDown drmForms.config.speed

        removeNotice: (status, message) ->
            notice = $ ".form-#{status}-notice:contains(#{message})"
            notice.slideUp drmForms.config.speed, -> 
                $(@).remove()  

        removeAllNotices: ->
            that = $ @
            notices = that.nextUntil(':input','.form-success-notice, .form-warning-notice, .form-danger-notice')
            notices.slideUp drmForms.config.speed, -> 
                $(@).remove()          

        applyValidationClass: (status) ->
            that = $ @
            switch status
                when 'danger' then drmForms.danger.call that
                when 'warning' then drmForms.warning.call that
                when 'success' then drmForms.success.call that

        removeValidationClass: ->
            that = $ @
            that.removeClass 'drm-form-danger'
            that.removeClass 'drm-form-warning'
            that.removeClass 'drm-form-success'

        validateEmpty: ->
            that = $ @
            value = $.trim that.val()

            if !value
                drmForms.removeValidationClass.call that
                drmForms.removeAllNotices.call that

        validateRequired: ->
            that = $ @
            status = null
            value = $.trim that.val()
            message = 'this field is required'

            if value.length == 0
                status = 'danger'
                drmForms.issueNotice.call(that, status, message)
            else
                drmForms.removeNotice('danger', message)

            drmForms.applyValidationClass.call(that, status)

        validateInteger: ->
            that = $ @
            status = null
            value = $.trim that.val()
            # an integer can be negative or positive and can include one comma separator followed by exactly 3 numbers
            re = new RegExp "^\\-?\\d*"

            evaluate = (result, value) ->
                message = 'please enter a valid integer'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateNumber: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp "^\\-?\\d*\\.?\\d*"

            evaluate = (result, value) ->
                message = 'please enter a valid number'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)       

            drmForms.applyValidationClass.call(that, status)

        validateURL: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^https?:\\/\\/[\\da-z\\.\\-]+[\\.a-z]{2,6}[\\/\\w/.\\-]*\\/?$','gi')

            evaluate = (result, value) ->
                message = 'please enter a valid url'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)        

            drmForms.applyValidationClass.call(that, status)

        validateEmail: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^[a-z][a-z\\-\\_\\.\\d]*@[a-z\\-\\_\\.\\d]*\\.[a-z]{2,6}$','gi')

            evaluate = (result, value) ->
                message = 'please enter a valid email address'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validatePhone: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^\\(?\\d{3}[\\)\\-\\.]?\\d{3}[\\-\\.]?\\d{4}(?:[xX]\\d+)?$','gi')

            evaluate = (result, value) ->
                message = 'please enter a valid phone number'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateFullName: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^[a-z]+ [a-z\\.\\- ]+$','gi')

            evaluate = (result, value) ->
                message = 'please enter your first and last name'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateAlpha: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^[a-z ]*','gi')

            evaluate = (result, value) ->
                message = 'please use alpha characters only'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateAlphaNum: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^[a-z\\d ]*$','gi')

            evaluate = (result, value) ->
                message = 'please use alphanumeric characters only'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateNoSpaces: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^\\S*$','gi')

            evaluate = (result, value) ->
                message = 'no spaces'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateAlphaNumDash: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('^[a-z\\d- ]*$','gi')

            evaluate = (result, value) ->
                message = 'please use alphanumeric and dashes only'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateAlphaNumUnderscore: ->
            that = $ @
            status = null
            value = $.trim that.val()
            # allows alphanumeric characters and underscores; no spaces
            re = new RegExp('^[a-z\\d_]*$','gi')

            evaluate = (result, value) ->
                message = 'please use alphanumeric and underscores only. no spaces'
                if result and value == result
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                else
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateNoTags: ->
            that = $ @
            status = null
            value = $.trim that.val()
            re = new RegExp('<[a-z]+.*>.*<\/[a-z]+>','i')

            evaluate = (result, value) ->
                message = 'no html tags allowed'
                if result
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                result = $.trim(re.exec value)
                status = evaluate(result, value)

            drmForms.applyValidationClass.call(that, status)

        validateMaxValue: ->
            that = $ @
            max = that.data 'max-value'
            value = $.trim that.val()

            evaluate = (max, value) ->
                message = "please enter a value that is less than #{max + 1}"
                if value > max
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                status = evaluate(max, value)

            drmForms.applyValidationClass.call(that, status)

        validateMinValue: ->
            that = $ @
            min = that.data 'min-value'
            value = $.trim that.val()

            evaluate = (min, value) ->
                message = "please enter a value of at least #{min}"
                if value < min
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                status = evaluate(min, value)

            drmForms.applyValidationClass.call(that, status)

        validateBetweenValue: ->
            that = $ @
            min = that.data 'min-value'
            max = that.data 'max-value'
            value = $.trim that.val()

            evaluate = (min, max, value) ->
                message = "please enter a value that is between #{min - 1} and #{max + 1}"
                if (value < min) or (value > max)
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                status = evaluate(min, max, value)

            drmForms.applyValidationClass.call(that, status)

        validateMaxLength: ->
            that = $ @
            max = that.data 'max-length'
            value = $.trim that.val()
            length = value.length

            evaluate = (max, length) ->
                message = "please enter less than #{max + 1} characters"
                if length > max
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                status = evaluate(max, length)

            drmForms.applyValidationClass.call(that, status)

        validateMinLength: ->
            that = $ @
            min = that.data 'min-length'
            value = $.trim that.val()
            length = value.length

            evaluate = (min, length) ->
                message = "please enter at least #{min} characters"
                if length < min
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                status = evaluate(min, length)

            drmForms.applyValidationClass.call(that, status)

        validateBetweenLength: ->
            that = $ @
            min = that.data 'min-length'
            max = that.data 'max-length'
            value = $.trim that.val()
            length = value.length

            evaluate = (min, max, length) ->
                message = "please enter a value that is between #{min - 1} and #{max + 1} characters"
                if (length < min) or (length > max)
                    status = 'danger'
                    drmForms.issueNotice.call(that, status, message)
                else
                    status = 'success'
                    drmForms.removeNotice('danger', message)
                return status

            if value
                status = evaluate(min, max, length)

            drmForms.applyValidationClass.call(that, status)
    }

    drmForms.init()
		
) jQuery