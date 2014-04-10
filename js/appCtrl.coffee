parseMoney = (moneyStr)->
    parseFloat(moneyStr.replace(/[\$,\,]/g,""))

app = angular.module('app',[])
app.controller 'appCtrl', ($scope, $http)->
    $scope.getData = ->
        $http.get('data/inventory_data.json').success (data)->
            dt = _(data)
            arr = []
            data.forEach((e)->
                f = _.find(arr, {department: e.department})
                if f?
                    f.inStockCount += e.inStockCount
                    f.toDateSpent += parseMoney(e.toDateSpent)
                    if f.elements?
                        f.elements.push(e)
                else
                    els = []
                    els.push(e)
                    arr.push
                        department: e.department
                        inStockCount : e.inStockCount
                        toDateSpent : parseMoney(e.toDateSpent)
                        elements: els

            )
            $scope.departmentsData = arr

            $scope.selectItem = (item) ->
                $scope.currentItem = item



app.directive 'invItem',->
    restrict:'E'
    scope:
        i:'=item'
        all:'=data'
    templateUrl:"item.html"
    link:(scope)->
        scope.addItem =(i)->
            i.inStockCount += 1
            f = _.find(scope.all, {department: i.department})
            f.inStockCount += 1
            f.toDateSpent += parseMoney(i.costPerUnit)

        scope.subtractItem =(i)->
            f = _.find(scope.all, {department: i.department})
            if i.inStockCount > 1
                i.inStockCount -= 1
                f.inStockCount -= 1
                f.toDateSpent -= parseMoney(i.costPerUnit)

