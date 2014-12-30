'use strict'

angular
	.module 'codoshopDonate', ['angular.filter', 'ngResource']
	.directive 'donate', ($resource) ->
		controller: ($scope) -> do ($s = $scope) ->

			$s.donList = [
				label: 'windows support'
				progress: 22
			,
				label: 'linux support'
				progress: 32
			,
				label: 'better performance'
				progress: 78
			]


			$s.custom = [{},{}]

			$s.amounts = new WeakMap()

			$s.getters = do (wm = $s.amounts) -> (k, type) ->
					(arg) -> do (v = wm.get(k) ? {}) ->
						if not arg
							return v[type] ? 0
						else
							v[type] = arg
							wm.set k, v
						return

			$s.total = do (wm = $s.amounts, $s) -> (type) -> do (keys = null) ->
				keys = [].concat $s.donList, $s.custom
				console.log type
				keys.reduce (p,k,i,a) ->
					do (v = wm.get(k) ? {}) ->
						if v[type] then p + v[type] else p
				, 0

			$s.paypal = do ($s) -> (payOpt) -> do (form = null, attr = null) ->
				if payOpt == 'once'
					form = $('#codoshop-donation-form')
					attr = 'value'
				else
					form = $('#codoshop-subscription-form')
					attr = 'a3'

				# $(document).trigger 'coinbase_show_modal', 'eae403700bd7f90f6afdd533d96c1a66'
				
				# $resource(url, [paramDefaults], [actions], options);
				# json =
				# 	button:
				# 		name: 'Codoshop donation'
				# 		price_string: '15.00'
				# 		price_currency_iso: 'USD'

				# r = $resource('https://api.coinbase.com/v1/buttons').get()
				# r = $resource 'https://api.coinbase.com/v1/buttons', {},
				# 	foo:
				# 		method: 'POST'
				# 		headers:
				# 			Accept: '*/*'
				# 			'Content-Type': 'application/json'
				# 			ACCESS_KEY: ''
				# 			ACCESS_NONCE: 50
							# Connection: 'close'
							# Host: 'coinbase.com'

				# r.foo json, (u, putResponseHeaders) ->
				# 	console.log u
				# 	return

				form.children('input[name="amount"]').attr attr, $s.total(payOpt)
				form.submit()
				return


			return

		link: (scope, el, attrs, ctrls) ->
			
			return