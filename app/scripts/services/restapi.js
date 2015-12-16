'use strict';

/**
 * @ngdoc service
 * @name estatisticasApp.RestApi
 * @description
 * # RestApi
 * Factory in the estatisticasApp.
 */


angular.module('estatisticasApp')
  .factory('RestApi', function ($resource) {
    // return $resource( 'http://10.1.8.210:8000/api/:type/', {type: '@type'},
    return $resource( 'http://siscom.ibama.gov.br/painel_api/api/:type/', {type: '@type'},
      {
        get: {
          method:'GET',
          params:{ format:'json' },
          isArray: true
        },
        post: {
          method:'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          isArray: true,
        },
        getDiario: {
          // url: 'http://10.1.8.210:8000/api/diario/:uf/:ano/:mes/:tipo/',
          method:  'GET',
          isArray: false,
          headers:{
            'Content-Type': 'application/json'
          }
        },
        obtain_pass : {
          url : 'http://siscom.ibama.gov.br/painel_api/login/obtain-pass/',
          method : 'POST',
          params : {
            format : 'json'
          },
          isArray : false
        }   
      },
      {stripTrailingSlashes: false}
    );
  });