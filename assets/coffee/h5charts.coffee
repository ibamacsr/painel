# DATA {{{
H5.Data.restURL = "http://" + document.domain + "/painel/rest"
H5.Data.domanin = "http://" + document.domain + "/painel"

H5.Data.changed = false
H5.DB.dado_prodes_consolidado = {}
H5.DB.dado_prodes_consolidado.table = "dado_prodes_consolidado"
H5.DB.rankings = {}
H5.DB.rankings.ranking_assentamento = {}
H5.DB.rankings.ranking_assentamento.table = "ranking_assentamento"
H5.DB.rankings.ranking_assentamento_estadual = {}
H5.DB.rankings.ranking_assentamento_estadual.table = "ranking_assentamento_estadual"
H5.DB.rankings.ranking_terra_indigena = {}
H5.DB.rankings.ranking_terra_indigena.table = "ranking_terra_indigena"
H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral = {}
H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral.table = "ranking_unidades_de_conservacao_protecao_integral"
H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual = {}
H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual.table = "ranking_unidades_de_conservacao_protecao_integral_estadual"
H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel = {}
H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel.table = "ranking_unidades_de_conservacao_uso_sustentavel"
H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual = {}
H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual.table = "ranking_unidades_de_conservacao_uso_sustentavel_estadual"
H5.Data.state2 = "brasil"
H5.Data.statesProdes = ["AC", "AP", "AM", "PA", "RO", "RR", "TO", "MT", "MA"]

# H5.Data.state3 = "brasil"
# H5.Data.statesNewStats = ["AC", "AM", "AP", "MA", "MT", "PA", "RO", "RR", "TO"]

H5.Data.state = "brasil"
H5.Data.states = ["AC", "AM", "AP", "MA", "MT", "PA", "RO", "RR", "TO"]
H5.Data.allstates = ["AC", "AL", "AP", "AM", "BA", "CE", "DF", "ES", "GO", "MA", "MT", "MS", "MG", "PA", "PB", "PR", "PE", "PI", "RJ", "RN", "RS", "RO", "RR", "SC", "SP", "SE", "TO"]
H5.Data.regions = {
  names: ["norte", "sul", "nordeste", "sudeste", "centrooeste"]
  amazonia: ["AC", "AP", "AM", "PA", "RO", "RR", "TO", "MT", "MA", "brasil"]
  norte: ["AC", "AP", "AM", "PA", "RO", "RR", "TO"]
  sul: ["PR", "RS", "SC"]
  nordeste: ["AL", "BA", "CE", "MA", "PB", "PE", "PI", "RN", "SE"]
  sudeste: ["ES", "MG", "RJ", "SP"]
  centrooeste: ["DF", "GO", "MT", "MS"]
}

H5.Data.years = [ "2015", "2014","2013", "2012", "2011", "2010", "2009", "2008", "2007", "2006","2005" ]

H5.Data.thisDate = new Date()
H5.Data.thisYear = H5.Data.thisDate.getFullYear()
H5.Data.thisProdesYear = if H5.Data.thisMonth < 7 then H5.Data.thisYear else H5.Data.thisYear + 1
H5.Data.thisMonth = H5.Data.thisDate.getMonth()
H5.Data.thisDay = H5.Data.thisDate.getDate()

H5.Data.rateSlct = 0;
H5.Data.shapeSlct = 0;

H5.Data.totalPeriods = if H5.Data.thisMonth < 7 then (H5.Data.thisDate.getFullYear() - 2005) else (H5.Data.thisDate.getFullYear() - 2004)
H5.Data.periods = new Array(H5.Data.totalPeriods)
for i in [0..H5.Data.totalPeriods]
  if H5.Data.thisMonth < 7
    H5.Data.periods[i] = (H5.Data.thisDate.getFullYear() - i - 1) + "-" + (H5.Data.thisDate.getFullYear() - i)
  else
    H5.Data.periods[i] = (H5.Data.thisDate.getFullYear() - i) + "-" + (H5.Data.thisDate.getFullYear() - i + 1)

H5.Data.months =
  0: "Ago"
  1: "Set"
  2: "Out"
  3: "Nov"
  4: "Dez"
  5: "Jan"
  6: "Fev"
  7: "Mar"
  8: "Abr"
  9: "Mai"
  10: "Jun"
  11: "Jul"

H5.Data.CompleteMonths =
  "AGOSTO" : 0
  "SETEMBRO" : 1
  "OUTUBRO" : 2
  "NOVEMBRO" : 3
  "DEZEMBRO" : 4
  "JANEIRO" : 5
  "FEVEREIRO" : 6
  "MARCO" : 7
  "ABRIL" : 8
  "MAIO" : 9
  "JUNHO" : 10
  "JULHO" : 11


# disable animation on mobile devices
unless H5.isMobile.any()
  H5.Data.animate = {
    duration: 500
    easing: "inAndOut"
  }
else
  H5.Data.animate = {}

#}}}
# DATABASES {{{
H5.DB.embargo.data =
  init: ->
    @states = {}
    for state in H5.Data.allstates
      @states[state] = {}

  populate: (state, date, value) ->
    # convert string into date
    if state and date

      convertDate = (dateStr) ->
        dateStr = String(dateStr)
        dArr = dateStr.split("-")
        return new Date(dArr[0], (dArr[1]) - 1, dArr[2])

      # populate object
      self = @states[state]
      self[date] = {}
      self[date].area = if value then value else 0
      self[date].date = convertDate(date)
      self[date].year = convertDate(date).getFullYear()
      self[date].month = convertDate(date).getMonth()
      self[date].day = convertDate(date).getDate()

      # set the value of the last value
      if @lastValue
        if @lastValue.date < self[date].date
          @lastValue = self[date]
      else
        @lastValue = self[date]
      return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.embargo.table
  # parameters: "data_cadastro > '2013-01-01'"
  fields: "uf, data_cadastro, qtd_area_desmatada"
)

H5.DB.embargo.data.init()
for i, properties of rest.data
  H5.DB.embargo.data.populate(
    properties.uf, properties.data_cadastro, parseFloat(properties.qtd_area_desmatada)
  )

H5.DB.diary.data =
  init: ->
    @states = {}
    for state in H5.Data.states
      @states[state] = {}

  populate: (state, date, value) ->
    # convert string into date
    convertDate = (dateStr) ->
      dateStr = String(dateStr)
      dArr = dateStr.split("-")
      return new Date(dArr[0], (dArr[1]) - 1, dArr[2])
    # populate object
    self = @states[state]
    self[date] = {}
    self[date].area = value
    self[date].date = convertDate(date)
    self[date].year = convertDate(date).getFullYear()
    self[date].month = convertDate(date).getMonth()
    self[date].day = convertDate(date).getDate()

    # set the value of the last value
    if @lastValue
      if @lastValue.date < self[date].date
        @lastValue = self[date]
    else
      @lastValue = self[date]
    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.diary.table
  fields: "estado, data, total"
)

H5.DB.diary.data.init()
for i, properties of rest.data
  H5.DB.diary.data.populate(
    properties.estado, properties.data, parseFloat(properties.total)
  )

H5.DB.prodes.data =
  init: ->
    @states = {}
    for state in H5.Data.states
      @states[state] = {}
      for period in H5.Data.periods
        @states[state][period] = {}

  populate: (period, ac, am, ap, ma, mt, pa, ro, rr, to) ->
    self = @states
    self.AC[period].area = ac
    self.AM[period].area = am
    self.AP[period].area = ap
    self.MA[period].area = ma
    self.MT[period].area = mt
    self.PA[period].area = pa
    self.RO[period].area = ro
    self.RR[period].area = rr
    self.TO[period].area = to

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.prodes.table
)

H5.DB.prodes.data.init()
for i, properties of rest.data
  H5.DB.prodes.data.populate(
    properties.ano_prodes.replace('/','-'),
    parseFloat(properties.ac), parseFloat(properties.am),
    parseFloat(properties.ap), parseFloat(properties.ma),
    parseFloat(properties.mt), parseFloat(properties.pa),
    parseFloat(properties.ro), parseFloat(properties.rr),
    parseFloat(properties.to)
  )

H5.DB.cloud.data =
  init: ->
    @nuvem = {}

  populate: (date, value) ->
    convertDate = (dateStr) ->
      dateStr = String(dateStr)
      dArr = dateStr.split("-")
      new Date(dArr[0], (dArr[1]) - 1, dArr[2])
    self = @nuvem
    self[date] = {}
    self[date].value = value
    self[date].date = convertDate(date)
    self[date].year = convertDate(date).getFullYear()
    self[date].month = convertDate(date).getMonth()
    self[date].day = convertDate(date).getDate()

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.cloud.table
)

H5.DB.cloud.data.init()
for i, properties of rest.data
  H5.DB.cloud.data.populate(
    properties.data, properties.percent,
  )
#}}}
# PRODES CONSOLIDADO {{{
H5.DB.dado_prodes_consolidado.data =
  init: ->
    @states = {}
    for state in H5.Data.allstates
      @states[state] = {}
    @states['brasil'] = {}

  populate: (year, state, terra_indigena, uc_sustentavel, uc_integral, assentamento, floresta, dominio, uc_sustentavel_estadual, uc_integral_estadual, assentamento_estadual, terra_arrecadada_estadual) ->
    # convert string into date
    if state and year

      # populate object
      self = @states[state]
      self[year] = {}
      self[year].terra_indigena = if terra_indigena then terra_indigena else 0
      self[year].uc_sustentavel = uc_sustentavel
      self[year].uc_integral = uc_integral
      self[year].uc_sustentavel_estadual = uc_sustentavel_estadual
      self[year].uc_integral_estadual = uc_integral_estadual
      self[year].assentamento = assentamento
      self[year].assentamento_estadual = assentamento_estadual
      self[year].floresta = floresta
      self[year].terra_arrecadada_estadual = terra_arrecadada_estadual
      self[year].dominio = dominio
      self[year].year = year

      # set the value of the last value
      if @lastValue
        if @lastValue.year < self[year].year
          @lastValue = self[year]
      else
        @lastValue = self[year]

      self = @states['brasil']
      if !self[year]
        self[year] = {}
        self[year].terra_indigena = 0
        self[year].uc_sustentavel = 0
        self[year].uc_integral = 0
        self[year].uc_sustentavel_estadual = 0
        self[year].uc_integral_estadual = 0
        self[year].assentamento = 0
        self[year].assentamento_estadual = 0
        self[year].floresta = 0
        self[year].terra_arrecadada_estadual = 0
        self[year].dominio = 0
        self[year].year = year

      self[year].terra_indigena += if terra_indigena then terra_indigena else 0
      self[year].uc_sustentavel += uc_sustentavel
      self[year].uc_integral += uc_integral
      self[year].uc_sustentavel_estadual += uc_sustentavel_estadual
      self[year].uc_integral_estadual += uc_integral_estadual
      self[year].assentamento += assentamento
      self[year].assentamento_estadual += assentamento_estadual
      self[year].floresta += floresta
      self[year].terra_arrecadada_estadual += terra_arrecadada_estadual
      self[year].dominio += dominio

      return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.dado_prodes_consolidado.table
  # parameters: "data_cadastro > '2013-01-01'"
  #fields: "ano, uf, terra_indigena, unidades_de_conservacao_uso_sustentavel, unidades_de_conservacao_protecao_integral, assentamentos, floresta_publica"
)

H5.DB.dado_prodes_consolidado.data.init()
for i, properties of rest.data
  H5.DB.dado_prodes_consolidado.data.populate(
    properties.ano, properties.uf, parseFloat(properties.terra_indigena), parseFloat(properties.unidades_de_conservacao_uso_sustentavel),parseFloat(properties.unidades_de_conservacao_protecao_integral), parseFloat(properties.assentamento), parseFloat(properties.floresta_publica), parseFloat(properties.dominio_estadual), parseFloat(properties.unidades_de_conservacao_uso_sustentavel_estadual), parseFloat(properties.unidades_de_conservacao_protecao_integral_estadual), parseFloat(properties.assentamento_estadual), parseFloat(properties.terra_arrecadada_estadual)
  )


# Calling ranking assentamento rest and getting data
H5.DB.rankings.ranking_assentamento.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_assentamento.table
)

H5.DB.rankings.ranking_assentamento.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_assentamento.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_assentamento
  )

# Calling ranking assentamento estadual rest and getting data
H5.DB.rankings.ranking_assentamento_estadual.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_assentamento_estadual.table
)

H5.DB.rankings.ranking_assentamento_estadual.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_assentamento_estadual.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_assentamento_estadual
  )

# Calling ranking terra indigena rest and getting data
H5.DB.rankings.ranking_terra_indigena.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_terra_indigena.table
)

H5.DB.rankings.ranking_terra_indigena.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_terra_indigena.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_terra_indigena
  )

# Calling ranking unidades de conservacao protecao integral and getting data
H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral.table
)

H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_unidades_de_conservacao_protecao_integral
  )

# Calling ranking unidades de conservacao protecao integral estadual rest and getting data
H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual.table
)

H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_unidades_de_conservacao_protecao_integral_estadual
  )

# Calling ranking unidades de conservacao uso sustentavel rest and getting data
H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel.table
)

H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_unidades_de_conservacao_uso_sustentavel
  )

# Calling ranking unidades de conservacao uso sustentavel estadual rest and getting data
H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual.data =
  init: ->
    @ranking = {}

  populate: (year, nome, area, id) ->
    self = @ranking
    self[id] = {}
    self[id].id = id
    self[id].year = year
    self[id].nome = nome
    self[id].area = area

    return

rest = new H5.Rest (
  url: H5.Data.restURL
  table: H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual.table
)

H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual.data.init()
for i, properties of rest.data
  H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual.data.populate(
    properties.ano, properties.nome, parseFloat(properties.area), properties.id_ranking_unidades_de_conservacao_uso_sustentavel_estadual
  )



#   terra_indigena_sum += properties.terra_indigena
#   uc_sustentavel_sum += properties.unidades_de_conservacao_uso_sustentavel
#   uc_integral_sum += properties.unidades_de_conservacao_protecao_integral
#   assentamento_sum += properties.assentamento
#   floresta_sum += properties.floresta_publica

# H5.DB.dado_prodes_consolidado.data.populate()


#}}}
# DETER CONSOLIDADO {{{
# H5.DB.dado_deter_consolidado.data =
#   init: ->
#     @states = {}
#     for state in H5.Data.allstates
#       @states[state] = {}

#   populate: (year, state, terra_indigena, uc_sustentavel, uc_integral, assentamento, floresta) ->
#     # convert string into date
#     if state and year

#       # populate object
#       self = @states[state]
#       self[year] = {}
#       self[year].terra_indigena = if terra_indigena then terra_indigena else 0
#       self[year].uc_sustentavel = uc_sustentavel
#       self[year].uc_integral = uc_integral
#       self[year].assentamento = assentamento
#       self[year].floresta = floresta
#       self[year].year = year

#       # set the value of the last value
#       if @lastValue
#         if @lastValue.year < self[year].year
#           @lastValue = self[year]
#       else
#         @lastValue = self[year]
#       return


#   getValues: ->
#     rest = new H5.Rest (
#       url: H5.Data.restURL
#       table: H5.DB.dado_deter_consolidado.table + "('" +  + "'" + "'')"
#     )

#     H5.DB.dado_prodes_consolidado.data.init()
#     for i, properties of rest.data
#       H5.DB.dado_prodes_consolidado.data.populate(
#         properties.ano, properties.uf, parseFloat(properties.terra_indigena), parseFloat(properties.unidades_de_conservacao_uso_sustentavel),parseFloat(properties.unidades_de_conservacao_protecao_integral), parseFloat(properties.assentamento), parseFloat(properties.floresta_publica)
#       )
#}}}
# RELOAD DATE {{{
# reload date based on database
H5.Data.thisDate = H5.DB.diary.data.lastValue.date
H5.Data.thisDay = H5.DB.diary.data.lastValue.day
H5.Data.thisMonth = H5.DB.diary.data.lastValue.month
H5.Data.thisYear = H5.DB.diary.data.lastValue.year
H5.Data.thisProdesYear = if H5.Data.thisMonth < 7 then H5.Data.thisYear else H5.Data.thisYear + 1

H5.Data.selectedYear = H5.Data.thisYear
H5.Data.selectedMonth = H5.Data.thisMonth
H5.Data.selectedType = 'deter'

H5.Data.totalPeriods = if H5.Data.thisMonth < 7 then (H5.Data.thisDate.getFullYear() - 2005) else (H5.Data.thisDate.getFullYear() - 2004)
H5.Data.periods = new Array(H5.Data.totalPeriods)
for i in [0..H5.Data.totalPeriods]
  if H5.Data.thisMonth < 7
    H5.Data.periods[i] = (H5.Data.thisDate.getFullYear() - i - 1) + "-" + (H5.Data.thisDate.getFullYear() - i)
  else
    H5.Data.periods[i] = (H5.Data.thisDate.getFullYear() - i) + "-" + (H5.Data.thisDate.getFullYear() - i + 1)
#}}}
# CHART1 {{{
chart1 = new H5.Charts.GoogleCharts (
  type: "Line"
  container: "chart1"
  title: "Alerta DETER: Índice Diário"
  buttons:
    export: true
    table: true
    minimize: true
    maximize: true
)

chart1.drawChart = ->
  if H5.Data.selectedType is 'deter'
    createTable = (state) =>
      sum = 0
      for day in [1..daysInMonth]
        for key, reg of H5.DB.diary.data.states[state]
          do (reg) ->
            if firstPeriod <= reg.date <= secondPeriod and reg.day is day
              sum += reg.area
              return false
        @data[0].setValue (day - 1), 1, Math.round((@data[0].getValue((day - 1), 1) + sum) * 100) / 100

    # create an empty table
    @createDataTable()

    @data[0].addColumn "number", "Dia"
    @data[0].addColumn "number", "Área"

    daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()
    firstPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, 1)
    secondPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, daysInMonth)
    data = []

    # populate table with 0
    for day in [1..daysInMonth]
      data[0] = day
      data[1] = 0
      @data[0].addRow data

    # populate table with real values
    if H5.Data.state is "brasil"
      for state of H5.DB.diary.data.states
        createTable state
    else
      createTable H5.Data.state

    months =
      0: "Janeiro"
      1: "Fevereiro"
      2: "Março"
      3: "Abril"
      4: "Maio"
      5: "Junho"
      6: "Julho"
      7: "Agosto"
      8: "Setembro"
      9: "Outubro"
      10: "Novembro"
      11: "Dezembro"

    @changeTitle "Alerta DETER: Índice Diário [" + months[H5.Data.selectedMonth] + "]"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      legend: "none"
      chartArea:
        width: "70%"
        height: "70%"
      colors: ['#3ABCFC']
      vAxis:
        title: "Área km²"
      hAxis:
        title: "Dias"
        gridlines:
          color: "#CCC"
          count: daysInMonth / 5
      animation: H5.Data.animate

  else if H5.Data.selectedType is 'awifs'
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart1"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Dia"
    @data[0].addColumn "number", "Área"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    # Disabling the buttons while the chart is drawing.
    # @_addBtn.disabled = true
    # @_delBtn.disabled = true


    months =
      0: "Janeiro"
      1: "Fevereiro"
      2: "Março"
      3: "Abril"
      4: "Maio"
      5: "Junho"
      6: "Julho"
      7: "Agosto"
      8: "Setembro"
      9: "Outubro"
      10: "Novembro"
      11: "Dezembro"

    @changeTitle "Alerta AWiFS: Índice Diário [" + months[H5.Data.selectedMonth] + "]"

    # google.visualization.events.addListener @chart[0], "ready", =>
    #   #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2


    daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()

    for i in [1..daysInMonth]
      data = [i.toString()]

      if rest.data[i]
        data[1] = rest.data[i]
      else
        data[1] = 0

      @data[0].addRow data

  else
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart1"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_indicar.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Dia"
    @data[0].addColumn "number", "Área"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    # Disabling the buttons while the chart is drawing.
    # @_addBtn.disabled = true
    # @_delBtn.disabled = true


    months =
      0: "Janeiro"
      1: "Fevereiro"
      2: "Março"
      3: "Abril"
      4: "Maio"
      5: "Junho"
      6: "Julho"
      7: "Agosto"
      8: "Setembro"
      9: "Outubro"
      10: "Novembro"
      11: "Dezembro"

    @changeTitle "Alerta AWiFS: Índice Diário [" + months[H5.Data.selectedMonth] + "]"

    # google.visualization.events.addListener @chart[0], "ready", =>
    #   #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2


    daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()

    for i in [1..daysInMonth]
      data = [i.toString()]

      if rest.data[i]
        data[1] = rest.data[i]
      else
        data[1] = 0

      @data[0].addRow data


  @chart[0].draw @data[0], options
#}}}
# CHART2 {{{
chart2 = new H5.Charts.GoogleCharts(
  type: "Area"
  container: "chart2"
  period: 2
  title: "Alerta DETER: Índice Mensal"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chart2._addBtn.onclick = ->
  chart2.options.period++
  chart2.drawChart()

chart2._delBtn.onclick = ->
  chart2.options.period--
  chart2.drawChart()

chart2.drawChart = ->
  @data = null
  if H5.Data.selectedType is 'deter'
    # sum values
    sumValues = (year, month) ->
      sum = 0
      firstPeriod = new Date(year - 1, 7, 1)
      secondPeriod = new Date(year , 7, 0)
      if H5.Data.state is "brasil"
        for name, state of H5.DB.diary.data.states
          for key, reg of state
            if firstPeriod <= reg.date <= secondPeriod and reg.month == month
              sum += reg.area
      else
        for key, reg of H5.DB.diary.data.states[H5.Data.state]
          if firstPeriod <= reg.date <= secondPeriod and reg.month == month
            sum += reg.area

      return Math.round(sum * 100) / 100

    # create an empty table
    @createDataTable()

    # init table
    @data[0].addColumn "string", "Mês"
    for i in [0...@options.period]
      @data[0].addColumn "number", H5.Data.periods[i]

    for month of H5.Data.months
      data = [H5.Data.months[month]]
      month = parseInt month
      if 7 <= (month + 7) <= 11 then month+= 7 else month-= 5
      for i in [1..@options.period]
        data[i] = sumValues(H5.Data.thisProdesYear - i + 1, month)
      @data[0].addRow data

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    # Disabling the buttons while the chart is drawing.
    @_addBtn.disabled = true
    @_delBtn.disabled = true

    google.visualization.events.addListener @chart[0], "ready", =>
      # Enabling only relevant buttons.
      @_addBtn.disabled = @options.period > H5.Data.totalPeriods
      @_delBtn.disabled = @options.period < 2

  else if H5.Data.selectedType is 'awifs'
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart2"
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Mês"
    @data[0].addColumn "number", "2011-2012"
    @data[0].addColumn "number", "2012-2013"
    @data[0].addColumn "number", "2013-2014"
    @data[0].addColumn "number", "2014-2015"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    # Disabling the buttons while the chart is drawing.
    # @_addBtn.disabled = true
    # @_delBtn.disabled = true

    @changeTitle "Alerta AWiFS: Índice Mensal"

    google.visualization.events.addListener @chart[0], "ready", =>
      @_addBtn.disabled = true
      @_delBtn.disabled = true
      #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [H5.Data.months[key]]
      data[1] = val[0]
      data[2] = val[1]
      data[3] = val[2]
      data[4] = val[3]
      @data[0].addRow data

  else
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart2"
      restService: "ws_geo_indicar.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Mês"
    @data[0].addColumn "number", "2013-2014"
    @data[0].addColumn "number", "2014-2015"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    # Disabling the buttons while the chart is drawing.
    # @_addBtn.disabled = true
    # @_delBtn.disabled = true

    @changeTitle "Alerta Indicar LANDSAT: Índice Mensal"

    google.visualization.events.addListener @chart[0], "ready", =>
      @_addBtn.disabled = true
      @_delBtn.disabled = true
      #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [H5.Data.months[key]]
      data[1] = val[0]
      data[2] = val[1]
      @data[0].addRow data



  @chart[0].draw @data[0], options
#}}}
# CHART3 {{{
chart3 = new H5.Charts.GoogleCharts(
  type: "Bar"
  container: "chart3"
  period: 1
  title: "Alerta DETER: Índice Períodos"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chart3._addBtn.onclick = ->
  chart3.options.period++
  chart3.drawChart()

chart3._delBtn.onclick = ->
  chart3.options.period--
  chart3.drawChart()

chart3.drawChart = ->
  # sum values
  sumValues = (firstPeriod, secondPeriod) ->
    sum = 0
    if H5.Data.state is "brasil"
      for name, state of H5.DB.diary.data.states
        for key, reg of state
          if firstPeriod <= reg.date <= secondPeriod
            sum += reg.area
    else
      for key, reg of H5.DB.diary.data.states[H5.Data.state]
        if firstPeriod <= reg.date <= secondPeriod
          sum += reg.area
    return Math.round(sum * 100) / 100

  # sum total values
  sumTotalValues = (year) ->
    firstPeriod = new Date(year - 1, 7, 1)
    secondPeriod = new Date(year, 7, 0)
    sumValues firstPeriod, secondPeriod

  # sum average values
  sumAvgValues = (year) ->
    month = H5.Data.selectedMonth
    firstPeriod = new Date(year - 1, 7, 1)
    if month > 6
      if month is H5.Data.thisMonth
        secondPeriod = new Date(year-1, month, H5.Data.thisDay)
      else
        secondPeriod = new Date(year-1, month+1, 0)
    else
      if month is H5.Data.thisMonth
        secondPeriod = new Date(year, month, H5.Data.thisDay)
      else
        secondPeriod = new Date(year, month+1, 0)
    sumValues firstPeriod, secondPeriod

  # create an empty table
  @createDataTable()

  # init table
  @data[0].addColumn "string", "Ano"
  @data[0].addColumn "number", "Parcial"
  @data[0].addColumn "number", "Diferença"

  # populate table
  for i in [0..@options.period]
    data = [H5.Data.periods[i]]
    sumTotal = sumTotalValues(H5.Data.thisProdesYear - i)
    sumAvg = sumAvgValues(H5.Data.thisProdesYear - i)
    data[1] = sumAvg
    data[2] = Math.round((sumTotal - sumAvg) * 100) / 100
    @data[0].addRow data

  options =
    title: ""
    titleTextStyle:
      color: "#333"
      fontSize: 13
    backgroundColor: "transparent"
    focusTarget: "category"
    chartArea:
      width: "68%"
      height: "76%"
    colors: ['#3ABCFC', '#FC2121']
    vAxis:
      title: "Período PRODES"
    hAxis:
      title: "Área km²"
    bar:
      groupWidth: "80%"
    isStacked: true
    animation: H5.Data.animate

  # Disabling the buttons while the chart is drawing.
  @_addBtn.disabled = true
  @_delBtn.disabled = true

  google.visualization.events.addListener @chart[0], "ready", =>
    # Enabling only relevant buttons.
    @_addBtn.disabled = @options.period > H5.Data.totalPeriods - 1
    @_delBtn.disabled = @options.period < 2

  @chart[0].draw @data[0], options
#}}}
# CHART4 {{{
chart4 = new H5.Charts.GoogleCharts(
  type: "Column"
  container: "chart4"
  period: 2
  title: "Alerta DETER: UFs"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chart4._addBtn.onclick = ->
  chart4.options.period++
  chart4.drawChart()

chart4._delBtn.onclick = ->
  chart4.options.period--
  chart4.drawChart()

chart4.drawChart = ->
  if H5.Data.selectedType is 'deter'
    # sum values
    sumValues = (state, year) ->
      sum = 0
      firstPeriod = new Date(year - 1, 7, 1)
      secondPeriod = new Date(year , 7, 0)
      for key, reg of H5.DB.diary.data.states[state]
        if firstPeriod <= reg.date <= secondPeriod
          sum += reg.area
      Math.round(sum * 100) / 100

    # create an empty table
    @createDataTable()

    # init table
    @data[0].addColumn "string", "Estado"
    for i in [0...@options.period]
      @data[0].addColumn "number", H5.Data.periods[i]

    # populate table with real values
    if H5.Data.state is "brasil"
      for name, state of H5.DB.diary.data.states
        data = [name]
        for j in [1..@options.period]
          data[j] = sumValues(name, H5.Data.thisProdesYear - j + 1)
        @data[0].addRow data
    else
      data = [H5.Data.state]
      for j in [1..@options.period]
        data[j] = sumValues(H5.Data.state, H5.Data.thisProdesYear - j + 1)
      @data[0].addRow data

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "76%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      bar:
        groupWidth: "100%"
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    # Disabling the buttons while the chart is drawing.
    @_addBtn.disabled = true
    @_delBtn.disabled = true

    google.visualization.events.addListener @chart[0], "ready", =>
      # Enabling only relevant buttons.
      @_addBtn.disabled = @options.period > H5.Data.totalPeriods
      @_delBtn.disabled = @options.period < 2

  else if H5.Data.selectedType is 'awifs'
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart4"
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "2011-2012"
    @data[0].addColumn "number", "2012-2013"
    @data[0].addColumn "number", "2013-2014"
    @data[0].addColumn "number", "2014-2015"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    @changeTitle "Alerta AWiFS: UFs"

    google.visualization.events.addListener @chart[0], "ready", =>
      @_addBtn.disabled = true
      @_delBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val[0]
      data[2] = val[1]
      data[3] = val[2]
      data[4] = val[3]
      @data[0].addRow data

  else
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart4"
      restService: "ws_geo_indicar.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "2013-2014"
    @data[0].addColumn "number", "2014-2015"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    @changeTitle "Alerta Indicar LANDSAT: UFs"

    google.visualization.events.addListener @chart[0], "ready", =>
      @_addBtn.disabled = true
      @_delBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val[0]
      data[2] = val[1]
      @data[0].addRow data


  @chart[0].draw @data[0], options
#}}}
# CHART5 {{{
chart5 = new H5.Charts.GoogleCharts(
  type: "Area"
  container: "chart5"
  title: "Taxa PRODES|Alerta DETER: Acumulado Períodos"
  buttons:
    export: true
    table: true
    minimize: true
    maximize: true
)

chart5.drawChart = ->
  @data = null
  if H5.Data.selectedType is 'deter'
    # sum values
    sumDeter = (year) ->
      sum = 0
      firstPeriod = new Date(year - 1, 7, 1)
      secondPeriod = new Date(year , 7, 0)
      if H5.Data.state is "brasil"
        for name, state of H5.DB.diary.data.states
          for key, reg of state
            if firstPeriod <= reg.date <= secondPeriod
              sum += reg.area
      else
        for key, reg of H5.DB.diary.data.states[H5.Data.state]
          if firstPeriod <= reg.date <= secondPeriod
            sum += reg.area
      return Math.round(sum * 100) / 100 if sum >= 0

    sumProdes = (period) ->
      sum = 0
      if H5.Data.state is "brasil"
        for name, state of H5.DB.prodes.data.states
          sum+= state[period].area
      else
        sum = H5.DB.prodes.data.states[H5.Data.state][period].area

      return sum if sum >= 0

    # create an empty table
    @createDataTable()

    # init table
    @data[0].addColumn "string", "Ano"
    @data[0].addColumn "number", "Alerta DETER"
    @data[0].addColumn "number", "Taxa PRODES"

    # populate table
    i = H5.Data.totalPeriods
    while i >= 0
      data = [H5.Data.periods[i]]
      data[1] = sumDeter(H5.Data.thisProdesYear - i)
      data[2] = sumProdes(H5.Data.periods[i])
      @data[0].addRow data
      i--

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "70%"
        height: "80%"
      colors: ['#3ABCFC', '#D0FC3F']
      vAxis:
        title: "Área km²"
      hAxis:
        title: "Período PRODES"
      animation: H5.Data.animate

  else
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart5"
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Ano"
    @data[0].addColumn "number", "Alerta AWiFS"
    @data[0].addColumn "number", "Taxa PRODES"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    @changeTitle "Taxa PRODES|Alerta AWiFS: Acumulado Períodos"

    # google.visualization.events.addListener @chart[0], "ready", =>
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val[0]
      data[2] = val[1]
      @data[0].addRow data


  @chart[0].draw @data[0], options
#}}}
# CHART6 {{{
chart6 = new H5.Charts.GoogleCharts(
  type: "Column"
  container: "chart6"
  period: 1
  title: "Taxa PRODES|Alerta DETER: UFs"
  buttons:
    export: true
    table: true
    minimize: true
    maximize: true
    arrows: true
)

chart6.changeTitle H5.Data.periods[chart6.options.period]

chart6._leftBtn.onclick = ->
  chart6.options.period++
  chart6.drawChart()

chart6._rightBtn.onclick = ->
  chart6.options.period--
  chart6.drawChart()

chart6.drawChart = ->
  if H5.Data.selectedType is 'deter'
    # sum values
    sumDeter = (state, year) ->
      sum = 0
      firstPeriod = new Date(year - 1, 7, 1)
      secondPeriod = new Date(year , 7, 0)
      for key, reg of H5.DB.diary.data.states[state]
        if firstPeriod <= reg.date <= secondPeriod
          sum+= reg.area
      return Math.round(sum * 100) / 100

    sumProdes = (state, year) ->
      sum = 0
      period = (year - 1) + "-" + (year)
      for key, reg of H5.DB.prodes.data.states[state]
        if key is period
          sum+= reg.area if reg.area?
      return Math.round(sum * 100) / 100

    # create an empty table
    @createDataTable()

    # init table
    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "Alerta DETER"
    @data[0].addColumn "number", "Taxa PRODES"

    # populate table with real values
    if H5.Data.state is "brasil"
      for name, state of H5.DB.diary.data.states
        data = [name]
        data[1] = sumDeter(name, H5.Data.thisProdesYear - @options.period)
        data[2] = sumProdes(name, H5.Data.thisProdesYear - @options.period)
        @data[0].addRow data
    else
      data = [H5.Data.state]
      data[1] = sumDeter(H5.Data.state, H5.Data.thisProdesYear - @options.period)
      data[2] = sumProdes(H5.Data.state, H5.Data.thisProdesYear - @options.period)
      @data[0].addRow data

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "70%"
        height: "76%"
      colors: ['#3ABCFC', '#D0FC3F']
      bar:
        groupWidth: "100%"
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    @changeTitle "Taxa PRODES|Alerta DETER: UFs [" + H5.Data.periods[@options.period] + "]"

    # Disabling the buttons while the chart is drawing.
    @_rightBtn.disabled = true
    @_leftBtn.disabled = true

    google.visualization.events.addListener @chart[0], "ready", =>
      # Enabling only relevant buttons.
      @_rightBtn.disabled = @options.period < 2
      @_leftBtn.disabled = @options.period >= H5.Data.totalPeriods

  else
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart6"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "Alerta AWiFS"
    @data[0].addColumn "number", "Taxa PRODES"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

    @changeTitle "Taxa PRODES|Alerta AWiFS: UFs"

    google.visualization.events.addListener @chart[0], "ready", =>
      @_rightBtn.disabled = true
      @_leftBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val[0]
      data[2] = val[1]
      @data[0].addRow data



  @chart[0].draw @data[0], options
#}}}
# CHART7 {{{
chart7 = new H5.Charts.GoogleCharts(
  type: "Pie"
  container: "chart7"
  period: 0
  buttons:
    arrows: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chart7.changeTitle H5.Data.periods[chart7.options.period]

chart7._leftBtn.onclick = ->
  chart7.options.period++
  chart7.drawChart()

chart7._rightBtn.onclick = ->
  chart7.options.period--
  chart7.drawChart()

chart7.drawChart = ->
  if H5.Data.selectedType is 'deter'
    # sum values
    sumValues = (state, year) ->
      sum = 0
      firstPeriod = new Date(year - 1, 7, 1)
      secondPeriod = new Date(year , 7, 0)
      for key, reg of H5.DB.diary.data.states[state]
        if firstPeriod <= reg.date <= secondPeriod
          sum += reg.area
      Math.round(sum * 100) / 100

    # create an empty table
    @createDataTable()

    # init table
    @data[0].addColumn "string", "Mês"
    @data[0].addColumn "number", H5.Data.periods[@options.period]

    # populate table
    for i in [0...H5.Data.states.length]
      estado = H5.Data.states[i]
      data = [estado]
      data[1] = sumValues(H5.Data.states[i], H5.Data.thisProdesYear - @options.period)
      @data[0].addRow data

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      chartArea:
        width: "90%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      backgroundColor: "transparent"

    @changeTitle H5.Data.periods[@options.period]

    # Disabling the buttons while the chart is drawing.
    @_rightBtn.disabled = true
    @_leftBtn.disabled = true

    google.visualization.events.addListener @chart[0], "ready", =>
      # Enabling only relevant buttons.
      @_rightBtn.disabled = @options.period < 1
      @_leftBtn.disabled = @options.period >= H5.Data.totalPeriods

  else if H5.Data.selectedType is 'awifs'
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart7"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    title = ""
    if H5.Data.selectedMonth <= 6
      title = (H5.Data.selectedYear - 1) + "-" + H5.Data.selectedYear
    else
      title = H5.Data.selectedYear + "-" + (H5.Data.selectedYear + 1)

    @data[0].addColumn "string", "Mês"
    @data[0].addColumn "number", title

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate


    @changeTitle title

    google.visualization.events.addListener @chart[0], "ready", =>
      @_rightBtn.disabled = true
      @_leftBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val[0]
      @data[0].addRow data

  else
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart7"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_indicar.php"
    )

    @createDataTable()

    title = ""
    if H5.Data.selectedMonth <= 6
      title = (H5.Data.selectedYear - 1) + "-" + H5.Data.selectedYear
    else
      title = H5.Data.selectedYear + "-" + (H5.Data.selectedYear + 1)

    @data[0].addColumn "string", "Mês"
    @data[0].addColumn "number", title

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate


    @changeTitle title

    google.visualization.events.addListener @chart[0], "ready", =>
      @_rightBtn.disabled = true
      @_leftBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val[0]
      @data[0].addRow data


  @chart[0].draw @data[0], options
#}}}
# CHART8 {{{
chart8 = new H5.Charts.GoogleCharts(
  type: "Pie"
  container: "chart8"
  period: 1
  buttons:
    export: true
    table: true
    minimize: true
    maximize: true
)

chart8.drawChart = ->
  if H5.Data.selectedType is 'deter'
    # sum values
    sumValues = (state) ->
      sum = 0
      for key, reg of H5.DB.diary.data.states[state]
        if firstPeriod <= reg.date <= secondPeriod
          sum += reg.area
      if firstPeriod > H5.Data.thisDate
        return 1
      else
        Math.round(sum * 100) / 100

    # create an empty table
    @createDataTable()

    # init table
    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "Área Total"

    daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()
    firstPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, 1)
    secondPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, daysInMonth)

    if firstPeriod > H5.Data.thisDate
      pieText = "none"
      pieTooltip = "none"
    else
      pieText = "percent"
      pieTooltip = "focus"

    # populate table
    for i in [0...H5.Data.states.length]
      estado = H5.Data.states[i]
      data = [estado]
      data[1] = sumValues(H5.Data.states[i])
      @data[0].addRow data

    @changeTitle selectMonths.options[H5.Data.selectedMonth].label + ", " + H5.Data.selectedYear

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      pieSliceText: pieText
      tooltip:
        trigger: pieTooltip
      chartArea:
        width: "90%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      bar:
        groupWidth: "100%"
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate

  else if H5.Data.selectedType is 'awifs'
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart8"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_awifs.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "Área Total"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate


    months =
      0: "Jan"
      1: "Fev"
      2: "Mar"
      3: "Abr"
      4: "Mai"
      5: "Jun"
      6: "Jul"
      7: "Ago"
      8: "Set"
      9: "Out"
      10: "Nov"
      11: "Dez"

    @changeTitle months[H5.Data.selectedMonth] + ", " + H5.Data.selectedYear

    google.visualization.events.addListener @chart[0], "ready", =>
      # @_rightBtn.disabled = true
      # @_leftBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val
      @data[0].addRow data

  else if H5.Data.selectedType is 'indicar'
    rest = new H5.Rest (
      url: H5.Data.restURL
      parameters: "chart8"
      ano: H5.Data.selectedYear
      mes: H5.Data.selectedMonth
      restService: "ws_geo_indicar.php"
    )

    @createDataTable()

    @data[0].addColumn "string", "Estado"
    @data[0].addColumn "number", "Área Total"

    options =
      title: ""
      titleTextStyle:
        color: "#333"
        fontSize: 13
      backgroundColor: "transparent"
      focusTarget: "category"
      chartArea:
        width: "67%"
        height: "80%"
      colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
               '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
               '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
      vAxis:
        title: "Área km²"
      animation: H5.Data.animate


    months =
      0: "Jan"
      1: "Fev"
      2: "Mar"
      3: "Abr"
      4: "Mai"
      5: "Jun"
      6: "Jul"
      7: "Ago"
      8: "Set"
      9: "Out"
      10: "Nov"
      11: "Dez"

    @changeTitle months[H5.Data.selectedMonth] + ", " + H5.Data.selectedYear

    google.visualization.events.addListener @chart[0], "ready", =>
      # @_rightBtn.disabled = true
      # @_leftBtn.disabled = true
    #   # Enabling only relevant buttons.
    #   @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    #   @_delBtn.disabled = @options.period < 2

    for key,val of rest.data
      data = [key]
      data[1] = val
      @data[0].addRow data


  @chart[0].draw @data[0], options
#}}}
# CHART9 {{{
chart9 = new H5.Charts.GoogleCharts(
  type: "Line"
  container: "chart9"
  period: 2
  title: "Alerta DETER: Taxa(%) de Nuvens"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chart9._addBtn.onclick = ->
  chart9.options.period++
  chart9.drawChart()

chart9._delBtn.onclick = ->
  chart9.options.period--
  chart9.drawChart()

chart9.drawChart = ->
  # sum values
  sumValues = (year, month) ->
    percent = 0
    firstPeriod = new Date(year - 1, 7, 1)
    secondPeriod = new Date(year , 7, 0)
    maxDate = firstPeriod
    for key, reg of  H5.DB.cloud.data.nuvem
      do (reg) ->
        if reg.date >= firstPeriod and reg.date <= secondPeriod and reg.month is month
          if reg.date >= maxDate
            maxDate = reg.date
            percent = reg.value
            return false

    return Math.round(percent * 100)

  # create an empty table
  @createDataTable()

  # init table
  @data[0].addColumn "string", "Mês"
  for i in [0...@options.period]
    @data[0].addColumn "number", H5.Data.periods[i]

  for month of H5.Data.months
    data = [H5.Data.months[month]]
    month = parseInt month
    if 7 <= (month + 7) <= 11 then month+= 7 else month-= 5
    for i in [1..@options.period]
      data[i] = sumValues(H5.Data.thisProdesYear - i + 1, month)
    @data[0].addRow data

  options =
    title: ""
    titleTextStyle:
      color: "#333"
      fontSize: 13
    backgroundColor: "transparent"
    focusTarget: "category"
    chartArea:
      width: "67%"
      height: "80%"
    colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
             '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
             '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
    vAxis:
      title: "Porcentagem"
    animation: H5.Data.animate

  # Disabling the buttons while the chart is drawing.
  @_addBtn.disabled = true
  @_delBtn.disabled = true

  google.visualization.events.addListener @chart[0], "ready", =>
    # Enabling only relevant buttons.
    @_addBtn.disabled = @options.period > H5.Data.totalPeriods - 4
    @_delBtn.disabled = @options.period < 2

  @chart[0].draw @data[0], options
#}}}
# QUICK BTNS 2
lastSelectedRegion = ""
$("#quick2 a").on "click", (e) ->
  e.preventDefault()

  return if H5.Data.state2 is this.id

  H5.Data.state2 = this.id

  # clean all selection
  $(this).each ->
    $("a").removeClass "active"

  $(this).addClass "active"

  # chart10.drawChart()

  # H5.Data.changed = true

# # #}}
# # CHART10 {{{
# chart10 = new H5.Charts.GoogleCharts  (
#   type: "Line"
#   container: "chart10"
#   title: "PRODES em Terras Indígenas"
#   loadingImage: '<img src="' + H5.Data.domanin  + '/assets/img/spinner.gif" id="loading_spinner" style="display: inline; padding-top:90px;" title="">'
#   buttons:
#     export: true
#     table: true
#     minimize: true
#     maximize: true
# )


# # Bind of variables triggered on the on click event when "Cruzar Dados" is pressed
# charts_content = {}
# charts_content._consultBtn = document.getElementById('consultBtn')

# charts_content._shapesSlct = document.getElementById('shapesSlct')
# charts_content._shapesSlct.options[0].selected = true
# charts_content._ratesSlct = document.getElementById('ratesSlct')
# # charts_content._ratesSlct.options[0].selected = true

# charts_content._dateBegin = document.getElementById('dateBegin')
# charts_content._dateEnd = document.getElementById('dateFinish')

# charts_content._yearsSlctCrossingData = document.getElementById('yearsSlctCrossingData')
# charts_content._domainSlct = document.getElementById('domainSlct')

# charts_content._stateGroup = document.getElementById('quick2').children
# charts_content._state = 'Brasil'

# $(charts_content._ratesSlct).on "change", (event) ->
#   if charts_content._ratesSlct.value is "0"
#     $("#ano_prodes").hide()
#     $("#periodo_deter").show()
#   else
#     $("#ano_prodes").show()
#     $("#periodo_deter").hide()

# $(charts_content._shapesSlct).on "change", (event) ->
#   charts_content._domainSlct.options["0"].selected = true
#   if charts_content._shapesSlct.value is "terra_indigena"
#     charts_content._domainSlct.disabled = true
#   else
#     charts_content._domainSlct.disabled = false


# $(charts_content._consultBtn).on "click", (event) ->
#   chart10.drawChart()
#   if charts_content._ratesSlct.value is "1"
#     chart13.drawChart()
#   else
#     $("#chart13").hide()

# $.each charts_content._stateGroup, ()->
#   $(@).on "click", (event) ->
#     charts_content._state = $(@).children('span').html() ? 'Brasil'

# chart10.drawChart = ->
#   createTable = (state) =>
#     sum = 0
#     for day in [1..daysInMonth]
#       $.each H5.DB.diary.data.states[state], (key, reg) ->
#         if firstPeriod <= reg.date <= secondPeriod and reg.day is day
#           sum += reg.area
#           return false
#       @data[0].setValue (day - 1), 1, Math.round((@data[0].getValue((day - 1), 1) + sum) * 100) / 100

#   @createDataTable()

#   @data[0].addColumn "string", "Ano"
#   @data[0].addColumn "number", "Área em km²"

#   data = []

#   areaSelected = charts_content._shapesSlct.value
#   rateSelected = charts_content._ratesSlct.value
#   dateBegin = charts_content._dateBegin.value
#   dateEnd = charts_content._dateEnd.value
#   domainSelected = charts_content._domainSlct.value
#   if charts_content._state isnt 'Brasil'
#     state = "'" + charts_content._state + "',"
#   else
#     state = ''


#   shapes =
#     "terra_indigena": "Terras Indígenas"
#     "uc_sustentavel": "Unidade de Conservação de uso sustentável"
#     "uc_integral": "Unidade de Conservação de proteção integral"
#     "assentamento": "Assentamento"
#     "floresta": "Floresta Pública"
#     # "dominio_publico": "Domínio Estadual"

#   rates =
#     "0": "DETER"
#     "1": "PRODES"


#   if rateSelected is '1'
#     stateData = H5.DB.dado_prodes_consolidado.data.states[H5.Data.state2]

#     switch areaSelected
#       when "terra_indigena"
#         for year in ["2010", "2011", "2012", "2013"]
#           data[0] = year
#           data[1] = parseFloat stateData[year].terra_indigena.toFixed(2)
#           @data[0].addRow data
#         break
#       when "assentamento"
#         if domainSelected is '0'
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].assentamento.toFixed(2)
#             @data[0].addRow data
#           break
#         else
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].assentamento_estadual.toFixed(2)
#             @data[0].addRow data
#           break
#       when "floresta"
#         if domainSelected is '0'
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].floresta.toFixed(2)
#             @data[0].addRow data
#           break
#         else
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].terra_arrecadada_estadual.toFixed(2)
#             @data[0].addRow data
#           break
#       when "uc_integral"
#         if domainSelected is '0'
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].uc_integral.toFixed(2)
#             @data[0].addRow data
#           break
#         else
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].uc_integral_estadual.toFixed(2)
#             @data[0].addRow data
#           break
#       when "uc_sustentavel"
#         if domainSelected is '0'
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].uc_sustentavel.toFixed(2)
#             @data[0].addRow data
#           break
#         else
#           for year in ["2010", "2011", "2012", "2013"]
#             data[0] = year
#             data[1] = parseFloat stateData[year].uc_sustentavel_estadual.toFixed(2)
#             @data[0].addRow data
#           break
#       # when "dominio_publico"
#       #   for year in ["2010", "2011", "2012", "2013"]
#       #     data[0] = year
#       #     data[1] = parseFloat stateData[year].uc_sustentavel.toFixed(2)
#       #     @data[0].addRow data
#       #   break

#   else

#     if !$("#loading").is ':visible'
#       @_loadScreen()

#     deter_area

#     switch areaSelected
#       when 'terra_indigena'
#         deter_area = "'" + 'terra_indigena'
#         break
#       when 'assentamento'
#         deter_area = "'" + 'assentamento'
#         break
#       when 'floresta'
#         deter_area = "'" + 'floresta_publica'
#         break
#       when 'uc_integral'
#         deter_area = "'" + 'unidade_conservacao'
#         break
#       when 'uc_sustentavel'
#         deter_area = "'" + 'unidade_conservacao'
#         break
#       else deter_area = ''

#     deter_area_state = if deter_area isnt '' then deter_area + "'," + state + "'" else state  + "'"

#     timeBegin = $.datepicker.parseDate('dd/mm/yy',dateBegin)
#     timeEnd = $.datepicker.parseDate('dd/mm/yy',dateEnd)

#     timeBetween = (timeEnd - timeBegin) / 1000 / 60 / 60 / 24

#     partialBegin = new Date(timeBegin)
#     partialEnd = new Date(timeBegin)

#     if state isnt ""
#       if areaSelected is 'uc_integral'
#         function_name = 'dados_deter_pi'
#       else if areaSelected is 'uc_sustentavel'
#         function_name = 'dados_deter_us'
#       else if areaSelected is 'dominio_publico'
#         function_name = 'dados_deter_total_outros'
#       else
#         function_name = 'dados_deter'
#     else
#       if areaSelected is 'dominio_publico'
#         function_name = 'dados_deter_total_outros_brasil'
#       else
#         function_name = 'dados_deter_brasil'

#     deter_field = ''
#     deter_table = function_name + "(" +
#             deter_area_state +
#             $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#             $.datepicker.formatDate('dd/mm/yy',partialBegin) + "') AS (resultado float)"

#     months = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']

#     if timeBetween < 50 # about a months and a half
#       console.log 'time to print by days'

#       while partialEnd.setDate(partialEnd.getDate() + 1) < timeEnd
#         deter_field += "(select * from " + function_name + "(" +
#             deter_area_state +
#             $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#             $.datepicker.formatDate('dd/mm/yy',partialEnd) + "') AS (resultado float)) as \"" + partialBegin.getDate() + "/" + months[partialBegin.getMonth()] + "\","

#         partialBegin = new Date(partialEnd)

#       partialEnd = timeEnd
#       deter_field += "(select * from " + function_name + "(" +
#           deter_area_state +
#           $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#           $.datepicker.formatDate('dd/mm/yy',partialEnd) + "') AS (resultado float)) as \"" + partialBegin.getDate() + "/" + months[partialBegin.getMonth()] + "\""

#     else if timeBetween < 730 # 2 years
#       console.log 'time to print by months'

#       partialEnd.setDate(1)

#       while partialEnd.setMonth(partialEnd.getMonth() + 1) < timeEnd
#         deter_field += "(select * from " + function_name + "(" +
#             deter_area_state +
#             $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#             $.datepicker.formatDate('dd/mm/yy',partialEnd) + "') AS (resultado float)) as \"" + months[partialBegin.getMonth()] + "/" + partialBegin.getFullYear() + "\","

#         partialBegin = new Date(partialEnd)

#       partialEnd = timeEnd
#       deter_field += "(select * from " + function_name + "(" +
#           deter_area_state +
#           $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#           $.datepicker.formatDate('dd/mm/yy',partialEnd) + "') AS (resultado float)) as \"" + months[partialBegin.getMonth()] + "/" + partialBegin.getFullYear() + "\""

#     else
#       console.log 'time to print by years'

#       partialEnd.setDate(1)
#       partialEnd.setMonth(0)

#       while partialEnd.setFullYear(partialEnd.getFullYear() + 1) < timeEnd
#         deter_field += "(select * from " + function_name + "(" +
#           deter_area_state +
#           $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#           $.datepicker.formatDate('dd/mm/yy',partialEnd) + "') AS (resultado float)) as \"" + partialBegin.getFullYear() + "\","

#         partialBegin = new Date(partialEnd)

#       partialEnd = timeEnd
#       deter_field += "(select * from " + function_name + "(" +
#           deter_area_state +
#           $.datepicker.formatDate('dd/mm/yy',partialBegin) + "','" +
#           $.datepicker.formatDate('dd/mm/yy',partialEnd) + "') AS (resultado float)) as \"" + partialBegin.getFullYear() + "\""


#     # getting values from the database
#     rest = new H5.Rest (
#       url: H5.Data.restURL
#       fields: deter_field
#       table: deter_table
#       restService: "ws_selectonlyquery.php"
#     )

#     $.each rest.data[0], (field,result)=>
#       data[0] = field.toString()
#       data[1] = if result then parseFloat(parseFloat(result).toFixed(2)) else 0
#       @data[0].addRow data



#   @changeTitle rates[rateSelected] + "  em " + shapes[areaSelected] + " [2010 - 2013]"

#   options =
#     title: ""
#     titleTextStyle:
#       color: "#333"
#       fontSize: 13
#     backgroundColor: "transparent"
#     legend: "none"
#     chartArea:
#       width: "70%"
#       height: "70%"
#     colors: ['#3ABCFC']
#     vAxis:
#       title: "Área km²"
#     animation: H5.Data.animate

#   @_chartScreen()

#   @chart[0].draw @data[0], options

# #}}}
# # CHART11 {{{
# chart11 = new H5.Charts.GoogleCharts  (
#   type: "SteppedArea"
#   container: "chart11"
#   period: 1
#   title: "Taxa de desmatamento PRODES - [2010 - 2013]"
#   buttons:
#     minusplus: true
#     export: true
#     table: true
#     minimize: true
#     maximize: true
# )

# chart11._addBtn.onclick = ->
#   chart11.options.period++
#   chart11.drawChart()

# chart11._delBtn.onclick = ->
#   chart11.options.period--
#   chart11.drawChart()


# chart11.drawChart = ->
#   createTable = (states) =>
#     sum = 0
#     totalsum = 0
#     data = []
#     i = 1

#     period = []

#     for j in [0..@options.period + 3]
#       period[j] = H5.Data.years[j]

#     for year in period
#       data[0] = year
#       for rate in ["terra_indigena" , "assentamento", "floresta", "uc_integral", "uc_sustentavel"]
#         for state in H5.Data.statesProdes
#           estado = H5.DB.dado_prodes_consolidado.data.states[state]
#           sum += estado[year][rate]

#         data[i] = parseFloat sum.toFixed(2)
#         i++
#         sum = 0

#       i = 1
#       @data[0].addRow data
#       @data[0].addRow [null, null, null, null, null, null]

#     @data[0].removeRow(@data[0].getNumberOfRows() - 1)
#   # create an empty table
#   @createDataTable()

#   @data[0].addColumn "string", "Ano"
#   @data[0].addColumn "number", "Terra indígena em km²"
#   @data[0].addColumn "number", "Assentamento em km²"
#   @data[0].addColumn "number", "Terras Arrecadadas em km²"
#   @data[0].addColumn "number", "UC Integral em km²"
#   @data[0].addColumn "number", "UC Sustentável em km²"

#   data = []

#   # populate table with real data
#   createTable "nenhumEstado"

#   @changeTitle "PRODES em [" + H5.Data.years[@options.period + 3] + " - " + H5.Data.years[0] + "]"

#   options =
#     title: ""
#     titleTextStyle:
#       color: "#333"
#       fontSize: 13
#     backgroundColor: "transparent"
#     focusTarget: "category"
#     connectSteps: "false"
#     chartArea:
#       width: "55%"
#       height: "80%"
#     colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
#              '#FF5454', '#C7A258', '#CBE968', '#FABB3D',
#              '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
#     vAxis:
#       title: "Área em km2"
#     isStacked: true
#     animation: H5.Data.animate

#   # Disabling the buttons while the chart is drawing.
#   @_addBtn.disabled = true
#   @_delBtn.disabled = true

#   google.visualization.events.addListener @chart[0], "ready", =>
#     # Enabling only relevant buttons.
#     @_delBtn.disabled = @options.period < 2
#     @_addBtn.disabled = @options.period >= 5

#   @chart[0].draw @data[0], options
# #}}}
# # CHART12 {{{
# chart12 = new H5.Charts.GoogleCharts(
#   type: "Pie"
#   container: "chart12"
#   period: 0
#   numberOfBox: 3
#   buttons:
#     arrows: true
#     export: true
#     table: true
#     minimize: true
#     maximize: true
# )

# chart12._leftBtn.onclick = ->
#   chart12.options.period++
#   chart12.drawChart()

# chart12._rightBtn.onclick = ->
#   chart12.options.period--
#   chart12.drawChart()

# years = H5.Data.years

# chart12.drawChart = ->
#   createTableEstadual = (graph) =>
#     data = []
#     sum = 0
#     # years = ["2010", "2011", "2012", "2013"]
#     years = H5.Data.years
#     year = years[chart12.options.period]
#     for rate in ["terra_indigena" , "floresta", "uc_integral", "uc_sustentavel"]
#       switch rate
#         when "terra_indigena"
#           data[0] = "Terras Indígenas"
#         # when "assentamento"
#         #   data[0] = "Assentamentos"
#         when "floresta"
#           data[0] = "Terras Arrecadadas"
#         when "uc_integral"
#           data[0] = "UC Integral"
#         when "uc_sustentavel"
#           data[0] = "UC Sustentável"
#       for state in H5.Data.statesProdes
#         estado = H5.DB.dado_prodes_consolidado.data.states[state]
#         sum += estado[year][rate]
#       data[1] = parseFloat sum.toFixed(2)
#       sum = 0
#       @data[graph].addRow data

#   createTableFederal = (graph) =>
#     data = []
#     sum = 0
#     sumUC = 0

#     years = H5.Data.years
#     year = years[chart12.options.period]
#     for rate in [ "assentamento", "uc_integral_estadual", "uc_sustentavel_estadual", "dominio" ]
#       switch rate
#         when "assentamento"
#           data[0] = "Assentamentos"
#         when "uc_integral_estadual"
#           data[0] = "UC Integral"
#         when "uc_sustentavel_estadual"
#           data[0] = "UC Sustentável"
#         when "dominio"
#           data[0] = "Demais Territórios do Estado"
#       for state in H5.Data.statesProdes
#         estado = H5.DB.dado_prodes_consolidado.data.states[state]
#         sum += estado[year][rate]
#         if rate is 'dominio'
#           sumUC += estado[year]['uc_integral_estadual'] + estado[year]['uc_sustentavel_estadual']

#       partialSum = parseFloat sum.toFixed(2) - parseFloat sumUC.toFixed(2)

#       data[1] = if partialSum > 0 then partialSum else 0
#       sum = 0
#       sumUC = 0
#       @data[graph].addRow data

#   createTableCompetencias = (graph) =>
#     data = []
#     sumFederal = 0
#     sumEstadual = 0
#     # years = ["2010", "2011", "2012", "2013"]
#     years = H5.Data.years
#     year = years[chart12.options.period]

#     for state in H5.Data.statesProdes
#       for territory in ['uc_sustentavel', 'uc_integral', 'terra_indigena', 'floresta', 'assentamento', 'dominio']
#         switch territory
#           when 'uc_sustentavel', 'uc_integral', 'terra_indigena', 'floresta'
#             estado = H5.DB.dado_prodes_consolidado.data.states[state]
#             sumFederal += estado[year][territory]
#           when 'assentamento', 'dominio'
#             estado = H5.DB.dado_prodes_consolidado.data.states[state]
#             sumEstadual += estado[year][territory]

#     for rate in ["federal" , "estadual"]
#       if rate is "federal"
#         data[0] = "Territórios de Competência Federal"
#         data[1] = parseFloat sumFederal.toFixed(2)
#       else
#         data[0] = "Territórios de Competência Estadual"
#         data[1] = parseFloat sumEstadual.toFixed(2)

#       @data[graph].addRow data



#   # create an empty table
#   @createDataTable()

#   for i in [0..@options.numberOfBox-1]
#     @data[i].addColumn "string", "Comparação"
#     @data[i].addColumn "number", "Área em km²"

#   # populate table with real data
#   # for i in [0..@options.numberOfBox-1]
#   createTableEstadual(0)
#   createTableCompetencias(1)
#   createTableFederal(2)

#   options =
#     title: ""
#     pieStartAngle: 80
#     titleTextStyle:
#       color: "#333"
#       fontSize: 13
#     backgroundColor: "transparent"
#     chartArea:
#       width: "90%"
#       height: "80%"
#     colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
#              '#FF5454', '#C7A258', '#CBE968', '#FABB3D',
#              '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']

#   @changeTitle "Território de Competência Estadual x Distribuição de Detecções por Competência de Fiscalização x Território de Competência Federal em " + years[@options.period]

#   # Disabling the buttons while the chart is drawing.
#   @_rightBtn.disabled = true
#   @_leftBtn.disabled = true

#   google.visualization.events.addListener @chart[0], "ready", =>
#     # Enabling only relevant buttons.
#     @_rightBtn.disabled = @options.period < 1
#     @_leftBtn.disabled = @options.period >= 8

#   for i in [0..@options.numberOfBox-1]
#     @chart[i].draw @data[i], options
# #}}}


# # CHART13 {{{
# chart13 = new H5.Charts.GoogleCharts  (
#   type: "Table"
#   container: "chart13"
#   period: 1
#   title: "Ranking PRODES"
#   buttons:
#     minusplus: false
#     export: true
#     table: false
#     minimize: true
#     maximize: true
# )


# chart13.drawChart = ->
#   createTable = (states) =>
#     # sum = 0
#     data = []
#     i = 1


#     yearSelected = charts_content._yearsSlctCrossingData.value
#     areaSelected = charts_content._shapesSlct.value
#     domainSelected = charts_content._domainSlct.value

#     if $("#chart13").css("display") == "none"
#       $("#chart13").show()
#     switch areaSelected
#       when "terra_indigena"
#           ranking = H5.DB.rankings.ranking_terra_indigena.data.ranking
#       when "uc_sustentavel"
#         if domainSelected is "0"
#           ranking = H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel.data.ranking
#         else
#           ranking = H5.DB.rankings.ranking_unidades_de_conservacao_uso_sustentavel_estadual.data.ranking
#       when "uc_integral"
#         if domainSelected is "0"
#           ranking = H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral.data.ranking
#         else
#           ranking = H5.DB.rankings.ranking_unidades_de_conservacao_protecao_integral_estadual.data.ranking
#       when "assentamento"
#         if domainSelected is "0"
#           ranking = H5.DB.rankings.ranking_assentamento.data.ranking
#         else
#           ranking = H5.DB.rankings.ranking_assentamento_estadual.data.ranking
#       when "floresta"
#         $("#chart13").hide()

#     for key, reg of ranking

#     # key = 2
#     # while key <= 10
#     #   reg = H5.DB.ranking_terra_indigena.data.ranking[key]
#       # do (reg) ->
#       if reg.year is yearSelected
#         data[0] = i
#         data[1] = reg.nome
#         data[2] = parseFloat reg.area.toFixed(2)
#           # key++
#           # return false
#         @data[0].addRow data
#         i++
#     # for year in ["2010", "2011", "2012", "2013"]
#     #   data[0] = year
#     #   for rate in ["terra_indigena" , "assentamento", "floresta", "uc_integral", "uc_sustentavel"]
#     #     for state in H5.Data.statesProdes
#     #       estado = H5.DB.dado_prodes_consolidado.data.states[state]
#     #       sum += estado[year][rate]
#     #     data[i] = sum
#     #     i++
#     #     sum = 0
#     #     # @data.setValue year, 1, sum
#     #   i = 1
#     #   @data.addRow data

#   # create an empty table
#   @createDataTable()

#   for i in [0..@options.numberOfBox-1]
#     @data[0].addColumn "number", "Ranking"
#     @data[0].addColumn "string", "Nome"
#     @data[0].addColumn "number", "Área"

#   # data = []

#   # populate table with real data
#   createTable "nenhumEstado"

#   yearSelected = charts_content._yearsSlctCrossingData.value
#   areaSelected = charts_content._shapesSlct.options[charts_content._shapesSlct.options.selectedIndex.toString()].label

#   @changeTitle "Ranking PRODES em " + areaSelected + " em " + yearSelected

#   options =
#     title: ""
#     titleTextStyle:
#       color: "#333"
#       fontSize: 13
#     backgroundColor: "transparent"
#     focusTarget: "category"
#     # chartArea:
#     width: "100%"
#     height: "220"
#     colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
#              '#FF5454', '#C7A258', '#CBE968', '#FABB3D',
#              '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
#     vAxis:
#       title: "Área em km2"
#     isStacked: true
#     animation: H5.Data.animate
#     pageSize: 10
#     page: 'enable'

#   @chart[0].draw @data[0], options
# #}}}


# SPARK1 {{{
spark1 = new H5.Charts.Sparks(
  container: "spark1"
  title: "Total Mensal"
)

spark1.drawChart = ->
  #Create array with values
  createTable = (state) =>
    dayValue = 0
    for day in [1..daysInMonth]
      for key, reg of H5.DB.diary.data.states[state]
        do (reg) ->
          if firstPeriod <= reg.date <= secondPeriod and reg.day is day
            dayValue += reg.area
            return false
      data[(day-1)] = Math.round((data[(day-1)] + dayValue) * 100)/100

  daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()
  firstPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, 1)
  secondPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, daysInMonth)
  data = []

  # populate table with 0
  for day in [1..daysInMonth]
    data[(day-1)] = 0

  # populate table with real values
  if H5.Data.state is "brasil"
    for name, state of H5.DB.diary.data.states
      createTable name
  else
    createTable H5.Data.state

  value = data[daysInMonth-1]
  @updateInfo data, value
#}}}
# SPARK2 {{{
spark2 = new H5.Charts.Sparks(
  container: "spark2"
  title: "Total Período"
)

spark2.drawChart = ->
  #Create array with values
  # sum values
  sumValues = (year, month) ->
    sum = 0
    firstPeriod = new Date(year - 1, 7, 1)
    if month > 6
      secondPeriod = new Date(year-1, month+1, 0)
    else if month != H5.Data.thisMonth
      secondPeriod = new Date(year, month+1, 0)
    else
      secondPeriod = new Date(year, month, H5.Data.thisDay)
    if H5.Data.state is "brasil"
      for name, state of H5.DB.diary.data.states
        for key, reg of state
          if firstPeriod <= reg.date <= secondPeriod and reg.month == month
            sum += reg.area
    else
      for key, reg of H5.DB.diary.data.states[H5.Data.state]
        if firstPeriod <= reg.date <= secondPeriod and reg.month == month
          sum += reg.area

    return Math.round(sum * 100) / 100

  # init table
  data = []

  for month of H5.Data.months

    month = parseInt month
    year = if H5.Data.selectedMonth < 7 then H5.Data.selectedYear else H5.Data.selectedYear + 1
    count = parseInt H5.Data.selectedMonth

    if count >= 7 then count-= 7 else count+= 5

    if month <= count
      if 7 <= (month + 7) <= 11 then month+= 7 else month-= 5
      data.push sumValues(year, month)
    else
      data.push 0

  value = 0
  $.each data, ->
    value += this

  @updateInfo data, Math.round(value*100)/100
#}}}
# KNOB1 {{{
knob1 = new H5.Charts.Knobs(
  container: "knob1"
  title: "Taxa VAA"
  popover: "Taxa de variação em relação ao mesmo mês do ano anterior"
)

knob1.drawChart = ->
  # sum values
  periodDeforesttionRate = (year, month) ->
    sumValues = (date) ->
      sum = 0
      if H5.Data.state is "brasil"
        for state of H5.DB.diary.data.states
          for reg of H5.DB.diary.data.states[state]
            reg = H5.DB.diary.data.states[state][reg]
            if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
              sum += reg.area
      else
        for reg of H5.DB.diary.data.states[H5.Data.state]
          reg = H5.DB.diary.data.states[H5.Data.state][reg]
          if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
            sum += reg.area
      return sum

    # definir periodo atual
    curDate = new Date(year, month)
    # definir periodo anterior
    preDate = new Date(year - 1, month)

    # definir valores referentes ao periodo atual
    curValue = sumValues(curDate)
    preValue = sumValues(preDate)

    # caso o valor do periodo anterior seja 0, retorna 0
    # para evitar uma divisão por 0
    if preValue is 0
      return 0
    else
      return Math.round (curValue - preValue) / preValue * 100

  value = periodDeforesttionRate(
    H5.Data.selectedYear, H5.Data.selectedMonth
  )
  @updateInfo value
#}}}
# KNOB2 {{{
knob2 = new H5.Charts.Knobs(
  container: "knob2"
  title: "Taxa VMA"
  popover: "Taxa de variação em relação ao mês anterior"
)

knob2.drawChart = ->
  # sum values
  periodDeforesttionRate = (year, month) ->
    sumValues = (date) ->
      sum = 0
      if H5.Data.state is "brasil"
        for state of H5.DB.diary.data.states
          for reg of H5.DB.diary.data.states[state]
            reg = H5.DB.diary.data.states[state][reg]
            if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
              sum += reg.area
      else
        for reg of H5.DB.diary.data.states[H5.Data.state]
          reg = H5.DB.diary.data.states[H5.Data.state][reg]
          if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
            sum += reg.area
      return sum

    # definir periodo atual
    curDate = new Date(year, month)
    # definir periodo anterior
    preDate = new Date(year, month - 1)

    # definir valores referentes ao periodo atual
    curValue = sumValues(curDate)
    preValue = sumValues(preDate)

    # caso o valor do periodo anterior seja 0, retorna 0
    # para evitar uma divisão por 0
    if preValue is 0
      return 0
    else
      return Math.round (curValue - preValue) / preValue * 100

  value = periodDeforesttionRate(
    H5.Data.selectedYear, H5.Data.selectedMonth
  )
  @updateInfo value
#}}}
# KNOB3 {{{
knob3 = new H5.Charts.Knobs(
  container: "knob3"
  title: "Taxa VPA"
  popover: "Taxa de variação em relação ao período PRODES anterior"
)

knob3.drawChart = ->
  # sum values
  periodDeforesttionAvgRate = (year, month) ->
    sumValues = (firstPeriod, secondPeriod) ->
      sum = 0
      if H5.Data.state is "brasil"
        for name, state of H5.DB.diary.data.states
          for key, reg of state
            if firstPeriod <= reg.date <= secondPeriod
              sum += reg.area
      else
        for key, reg of H5.DB.diary.data.states[H5.Data.state]
          if firstPeriod <= reg.date <= secondPeriod
            sum += reg.area
      return Math.round(sum * 100) / 100

    if month > 6 then year++ else year

    sumPeriods = (year, month) ->
      firstPeriod = new Date(year-1, 7, 1)
      if month > 6
        if month is H5.Data.thisMonth
          # secondPeriod = new Date(year-1, month, H5.Data.thisDay)
          secondPeriod = new Date(year-1, month + 1,  1 - 1)
        else
          secondPeriod = new Date(year-1, month+1, 0)
      else
        if month is H5.Data.thisMonth
          # secondPeriod = new Date(year, month, H5.Data.thisDay)
          secondPeriod = new Date(year, month + 1, 1 - 1)
        else
          secondPeriod = new Date(year, month+1, 0)
      sumValues firstPeriod, secondPeriod

    curValue = sumPeriods(year, month)
    preValue = sumPeriods(year-1, month)

    # caso o valor do periodo anterior seja 0, retorna 0
    # para evitar uma divisão por 0
    if preValue is 0
      return 0
    else
      return Math.round (curValue - preValue) / preValue * 100

  value = periodDeforesttionAvgRate(
    H5.Data.selectedYear, H5.Data.selectedMonth
  )
  @updateInfo value
#}}}
# chartDailyEmbargo {{{
chartDailyEmbargo = new H5.Charts.GoogleCharts (
  type: "Line"
  container: "chart-daily-embargo"
  title: "Embargos: Índice Diário"
  buttons:
    export: true
    table: true
    minimize: true
    maximize: true
)

chartDailyEmbargo.drawChart = ->
  createTable = (state) =>
    sum = 0
    for day in [1..daysInMonth]
      for key, reg of H5.DB.embargo.data.states[state]
        do (reg) ->
          if firstPeriod <= reg.date <= secondPeriod and reg.day is day
            sum += reg.area
            return false
      @data[0].setValue (day - 1), 1, Math.round((@data[0].getValue((day - 1), 1) + sum) * 100) / 100

  # create an empty table
  @createDataTable()

  @data[0].addColumn "number", "Dia"
  @data[0].addColumn "number", "Área"

  daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()
  firstPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, 1)
  secondPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, daysInMonth)
  data = []

  # populate table with 0
  for day in [1..daysInMonth]
    data[0] = day
    data[1] = 0
    @data[0].addRow data

  # populate table with real values
  if H5.Data.state is "brasil"
    for name of H5.DB.embargo.data.states
      createTable name
  else
    createTable H5.Data.state

  months =
    0: "Janeiro"
    1: "Fevereiro"
    2: "Março"
    3: "Abril"
    4: "Maio"
    5: "Junho"
    6: "Julho"
    7: "Agosto"
    8: "Setembro"
    9: "Outubro"
    10: "Novembro"
    11: "Dezembro"

  @changeTitle "Embargos: Índice Diário [" + months[H5.Data.selectedMonth] + "]"

  options =
    title: ""
    titleTextStyle:
      color: "#333"
      fontSize: 13
    backgroundColor: "transparent"
    legend: "none"
    chartArea:
      width: "70%"
      height: "70%"
    colors: ['#3ABCFC']
    vAxis:
      title: "Área km²"
    hAxis:
      title: "Dias"
      gridlines:
        color: "#CCC"
        count: daysInMonth / 5
    animation: H5.Data.animate

  @chart[0].draw @data[0], options
#}}}
# chartMonthlyEmbargo {{{
chartMonthlyEmbargo = new H5.Charts.GoogleCharts(
  type: "Area"
  container: "chart-monthly-embargo"
  period: 2
  title: "Embargos: Índice Mensal"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chartMonthlyEmbargo._addBtn.onclick = ->
  chartMonthlyEmbargo.options.period++
  chartMonthlyEmbargo.drawChart()

chartMonthlyEmbargo._delBtn.onclick = ->
  chartMonthlyEmbargo.options.period--
  chartMonthlyEmbargo.drawChart()

chartMonthlyEmbargo.drawChart = ->
  # sum values
  sumValues = (year, month) ->
    sum = 0
    firstPeriod = new Date(year - 1, 7, 1)
    secondPeriod = new Date(year , 7, 0)
    if H5.Data.state is "brasil"
      for name, state of H5.DB.embargo.data.states
        for key, reg of state
          if firstPeriod <= reg.date <= secondPeriod and reg.month == month
            sum += reg.area
    else
      for key,reg of H5.DB.embargo.data.states[H5.Data.state]
        if firstPeriod <= reg.date <= secondPeriod and reg.month == month
          sum += reg.area

    return Math.round(sum * 100) / 100

  # create an empty table
  @createDataTable()

  # init table
  @data[0].addColumn "string", "Mês"
  for i in [0...@options.period]
    @data[0].addColumn "number", H5.Data.periods[i]

  for month of H5.Data.months
    data = [H5.Data.months[month]]
    month = parseInt month
    if 7 <= (month + 7) <= 11 then month+= 7 else month-= 5
    for i in [1..@options.period]
      data[i] = sumValues(H5.Data.thisProdesYear - i + 1, month)
    @data[0].addRow data

  options =
    title: ""
    titleTextStyle:
      color: "#333"
      fontSize: 13
    backgroundColor: "transparent"
    focusTarget: "category"
    chartArea:
      width: "70%"
      height: "80%"
    colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
             '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
             '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
    vAxis:
      title: "Área km²"
    animation: H5.Data.animate

  # Disabling the buttons while the chart is drawing.
  @_addBtn.disabled = true
  @_delBtn.disabled = true

  google.visualization.events.addListener @chart[0], "ready", =>
    # Enabling only relevant buttons.
    @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    @_delBtn.disabled = @options.period < 2

  @chart[0].draw @data[0], options
#}}}
# chartAnnualEmbargo {{{
chartAnnualEmbargo = new H5.Charts.GoogleCharts(
  type: "Bar"
  container: "chart-annual-embargo"
  period: 1
  title: "Embargos: Índice Períodos"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chartAnnualEmbargo._addBtn.onclick = ->
  chartAnnualEmbargo.options.period++
  chartAnnualEmbargo.drawChart()

chartAnnualEmbargo._delBtn.onclick = ->
  chartAnnualEmbargo.options.period--
  chartAnnualEmbargo.drawChart()

chartAnnualEmbargo.drawChart = ->
  # sum values
  sumValues = (firstPeriod, secondPeriod) ->
    sum = 0
    if H5.Data.state is "brasil"
      for name, state of H5.DB.embargo.data.states
        for key, reg of state
          if firstPeriod <= reg.date <= secondPeriod
            sum += reg.area
    else
      for key, reg of H5.DB.embargo.data.states[H5.Data.state]
        if firstPeriod <= reg.date <= secondPeriod
          sum += reg.area
    return Math.round(sum * 100) / 100

  # sum total values
  sumTotalValues = (year) ->
    firstPeriod = new Date(year - 1, 7, 1)
    secondPeriod = new Date(year, 7, 0)
    sumValues firstPeriod, secondPeriod

  # sum average values
  sumAvgValues = (year) ->
    month = H5.Data.selectedMonth
    firstPeriod = new Date(year - 1, 7, 1)
    if month > 6
      if month is H5.Data.thisMonth
        secondPeriod = new Date(year-1, month, H5.Data.thisDay)
      else
        secondPeriod = new Date(year-1, month+1, 0)
    else
      if month is H5.Data.thisMonth
        secondPeriod = new Date(year, month, H5.Data.thisDay)
      else
        secondPeriod = new Date(year, month+1, 0)
    sumValues firstPeriod, secondPeriod

  # create an empty table
  @createDataTable()

  # init table
  @data[0].addColumn "string", "Ano"
  @data[0].addColumn "number", "Parcial"
  @data[0].addColumn "number", "Diferença"

  # populate table
  for i in [0..@options.period]
    data = [H5.Data.periods[i]]
    sumTotal = sumTotalValues(H5.Data.thisProdesYear - i)
    sumAvg = sumAvgValues(H5.Data.thisProdesYear - i)
    data[1] = sumAvg
    data[2] = Math.round((sumTotal - sumAvg) * 100) / 100
    @data[0].addRow data

  options =
    title: ""
    titleTextStyle:
      color: "#333"
      fontSize: 13
    backgroundColor: "transparent"
    focusTarget: "category"
    chartArea:
      width: "68%"
      height: "76%"
    colors: ['#3ABCFC', '#FC2121']
    vAxis:
      title: "Período PRODES"
    hAxis:
      title: "Área km²"
    bar:
      groupWidth: "80%"
    isStacked: true
    animation: H5.Data.animate

  # Disabling the buttons while the chart is drawing.
  @_addBtn.disabled = true
  @_delBtn.disabled = true

  google.visualization.events.addListener @chart[0], "ready", =>
    # Enabling only relevant buttons.
    @_addBtn.disabled = @options.period > H5.Data.totalPeriods - 1
    @_delBtn.disabled = @options.period < 2

  @chart[0].draw @data[0], options
#}}}
# chartStatesEmbargo {{{
chartStatesEmbargo = new H5.Charts.GoogleCharts(
  type: "Column"
  container: "chart-states-embargo"
  period: 2
  title: "Embargos: UFs"
  buttons:
    minusplus: true
    export: true
    table: true
    minimize: true
    maximize: true
)

chartStatesEmbargo._addBtn.onclick = ->
  chartStatesEmbargo.options.period++
  chartStatesEmbargo.drawChart()

chartStatesEmbargo._delBtn.onclick = ->
  chartStatesEmbargo.options.period--
  chartStatesEmbargo.drawChart()

chartStatesEmbargo.drawChart = ->
  # sum values
  sumValues = (state, year) ->
    sum = 0
    firstPeriod = new Date(year - 1, 7, 1)
    secondPeriod = new Date(year , 7, 0)
    for key, reg of H5.DB.embargo.data.states[state]
      if firstPeriod <= reg.date <= secondPeriod
        sum += reg.area
    Math.round(sum * 100) / 100

  # create an empty table
  @createDataTable()

  # init table
  @data[0].addColumn "string", "Estado"
  for i in [0...@options.period]
    @data[0].addColumn "number", H5.Data.periods[i]

  # populate table with real values
  if H5.Data.state is "brasil"
    for name, state of H5.DB.embargo.data.states
      data = [name]
      for j in [1..@options.period]
        data[j] = sumValues(name, H5.Data.thisProdesYear - j + 1)
      @data[0].addRow data
  else
    data = [H5.Data.state]
    for j in [1..@options.period]
      data[j] = sumValues(H5.Data.state, H5.Data.thisProdesYear - j + 1)
    @data[0].addRow data

  options =
    title: ""
    titleTextStyle:
      color: "#333"
      fontSize: 13
    backgroundColor: "transparent"
    focusTarget: "category"
    chartArea:
      width: "70%"
      height: "76%"
    colors: ['#3ABCFC', '#FC2121', '#D0FC3F', '#FCAC0A',
             '#67C2EF', '#FF5454', '#CBE968', '#FABB3D',
             '#77A4BD', '#CC6C6C', '#A6B576', '#C7A258']
    bar:
      groupWidth: "100%"
    vAxis:
      title: "Área km²"
    animation: H5.Data.animate

  # Disabling the buttons while the chart is drawing.
  @_addBtn.disabled = true
  @_delBtn.disabled = true

  google.visualization.events.addListener @chart[0], "ready", =>
    # Enabling only relevant buttons.
    @_addBtn.disabled = @options.period > H5.Data.totalPeriods
    @_delBtn.disabled = @options.period < 2

  @chart[0].draw @data[0], options
#}}}
# sparkTVAAEmbargo {{{
sparkTVAAEmbargo = new H5.Charts.Knobs(
  container: "spark-tvaa-embargo"
  title: "Taxa VAA"
  popover: "Taxa de variação em relação ao mesmo mês do ano anterior"
)

sparkTVAAEmbargo.drawChart = ->
  # sum values
  periodDeforesttionRate = (year, month) ->
    sumValues = (date) ->
      sum = 0
      if H5.Data.state is "brasil"
        for state of H5.DB.embargo.data.states
          for reg of H5.DB.embargo.data.states[state]
            reg = H5.DB.embargo.data.states[state][reg]
            if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
              sum += reg.area
      else
        for reg of H5.DB.embargo.data.states[H5.Data.state]
          reg = H5.DB.embargo.data.states[H5.Data.state][reg]
          if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
            sum += reg.area
      return sum

    # definir periodo atual
    curDate = new Date(year, month)
    # definir periodo anterior
    preDate = new Date(year - 1, month)

    # definir valores referentes ao periodo atual
    curValue = sumValues(curDate)
    preValue = sumValues(preDate)

    # caso o valor do periodo anterior seja 0, retorna 0
    # para evitar uma divisão por 0
    if preValue is 0
      return 0
    else
      return Math.round (curValue - preValue) / preValue * 100

  value = periodDeforesttionRate(
    H5.Data.selectedYear, H5.Data.selectedMonth
  )
  @updateInfo value
#}}}
# sparkTVMAEmbargo {{{
sparkTVMAEmbargo = new H5.Charts.Knobs(
  container: "spark-tvma-embargo"
  title: "Taxa VMA"
  popover: "Taxa de variação em relação ao mês anterior"
)

sparkTVMAEmbargo.drawChart = ->
  # sum values
  periodDeforesttionRate = (year, month) ->
    sumValues = (date) ->
      sum = 0
      if H5.Data.state is "brasil"
        for state of H5.DB.embargo.data.states
          for reg of H5.DB.embargo.data.states[state]
            reg = H5.DB.embargo.data.states[state][reg]
            if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
              sum += reg.area
      else
        for reg of H5.DB.embargo.data.states[H5.Data.state]
          reg = H5.DB.embargo.data.states[H5.Data.state][reg]
          if date.getFullYear() <= reg.year <= date.getFullYear() and reg.month is date.getMonth()
            sum += reg.area
      return sum

    # definir periodo atual
    curDate = new Date(year, month)
    # definir periodo anterior
    preDate = new Date(year, month - 1)

    # definir valores referentes ao periodo atual
    curValue = sumValues(curDate)
    preValue = sumValues(preDate)

    # caso o valor do periodo anterior seja 0, retorna 0
    # para evitar uma divisão por 0
    if preValue is 0
      return 0
    else
      return Math.round (curValue - preValue) / preValue * 100

  value = periodDeforesttionRate(
    H5.Data.selectedYear, H5.Data.selectedMonth
  )
  @updateInfo value
#}}}
# sparkTVPAEmbargo {{{
sparkTVPAEmbargo = new H5.Charts.Knobs(
  container: "spark-tvpa-embargo"
  title: "Taxa VPA"
  popover: "Taxa de variação em relação ao período PRODES anterior"
)

sparkTVPAEmbargo.drawChart = ->
  # sum values
  periodDeforesttionAvgRate = (year, month) ->
    sumValues = (firstPeriod, secondPeriod) ->
      sum = 0
      if H5.Data.state is "brasil"
        for name, state of H5.DB.embargo.data.states
          for key, reg of state
            if firstPeriod <= reg.date <= secondPeriod
              sum += reg.area
      else
        for key, reg of H5.DB.embargo.data.states[H5.Data.state]
          if firstPeriod <= reg.date <= secondPeriod
            sum += reg.area
      return Math.round(sum * 100) / 100

    if month > 6 then year++ else year

    sumPeriods = (year, month) ->
      firstPeriod = new Date(year-1, 7, 1)
      if month > 6
        if month is H5.Data.thisMonth
          secondPeriod = new Date(year-1, month, H5.Data.thisDay)
        else
          secondPeriod = new Date(year-1, month+1, 0)
      else
        if month is H5.Data.thisMonth
          secondPeriod = new Date(year, month, H5.Data.thisDay)
        else
          secondPeriod = new Date(year, month+1, 0)
      sumValues firstPeriod, secondPeriod

    curValue = sumPeriods(year, month)
    preValue = sumPeriods(year-1, month)

    # caso o valor do periodo anterior seja 0, retorna 0
    # para evitar uma divisão por 0
    if preValue is 0
      return 0
    else
      return Math.round (curValue - preValue) / preValue * 100

  value = periodDeforesttionAvgRate(
    H5.Data.selectedYear, H5.Data.selectedMonth
  )
  @updateInfo value
#}}}
# sparkMonthlyEmbargo {{{
sparkMonthlyEmbargo = new H5.Charts.Sparks(
  container: "spark-monthly-embargo"
  title: "Total Mensal"
)

sparkMonthlyEmbargo.drawChart = ->
  #Create array with values
  createTable = (state) =>
    dayValue = 0
    for day in [1..daysInMonth]
      for key, reg of H5.DB.embargo.data.states[state]
        do (reg) ->
          if firstPeriod <= reg.date <= secondPeriod and reg.day is day
            dayValue += reg.area
            return false
      data[(day-1)] = Math.round((data[(day-1)] + dayValue) * 100)/100

  daysInMonth = new Date(H5.Data.selectedYear, H5.Data.selectedMonth + 1, 0).getDate()
  firstPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, 1)
  secondPeriod = new Date(H5.Data.selectedYear, H5.Data.selectedMonth, daysInMonth)
  data = []

  # populate table with 0
  for day in [1..daysInMonth]
    data[(day-1)] = 0

  # populate table with real values
  if H5.Data.state is "brasil"
    for name, state of H5.DB.embargo.data.states
      createTable name
  else
    createTable H5.Data.state

  value = data[daysInMonth-1]
  @updateInfo data, value
#}}}
# sparkAnnualEmbargo {{{
sparkAnnualEmbargo = new H5.Charts.Sparks(
  container: "spark-annual-embargo"
  title: "Total Período"
)

sparkAnnualEmbargo.drawChart = ->
  #Create array with values
  # sum values
  sumValues = (year, month) ->
    sum = 0
    firstPeriod = new Date(year - 1, 7, 1)
    if month > 6
      secondPeriod = new Date(year-1, month+1, 0)
    else if month != H5.Data.thisMonth
      secondPeriod = new Date(year, month+1, 0)
    else
      secondPeriod = new Date(year, month, H5.Data.thisDay)
    if H5.Data.state is "brasil"
      for name, state of H5.DB.embargo.data.states
        for key, reg of state
          if firstPeriod <= reg.date <= secondPeriod and reg.month == month
            sum += reg.area
    else
      for key, reg of H5.DB.embargo.data.states[H5.Data.state]
        if firstPeriod <= reg.date <= secondPeriod and reg.month == month
          sum += reg.area

    return Math.round(sum * 100) / 100

  # init table
  data = []

  for month of H5.Data.months

    month = parseInt month
    year = if H5.Data.selectedMonth < 7 then H5.Data.selectedYear else H5.Data.selectedYear + 1
    count = parseInt H5.Data.selectedMonth

    if count >= 7 then count-= 7 else count+= 5

    if month <= count
      if 7 <= (month + 7) <= 11 then month+= 7 else month-= 5
      data.push sumValues(year, month)
    else
      data.push 0

  value = 0
  $.each data, ->
    value += this

  @updateInfo data, Math.round(value*100)/100
#}}}
# controllers {{{
reloadChartsDeter = ->
  chart1.drawChart()
  chart2.drawChart()
  chart3.drawChart()
  chart4.drawChart()
  chart5.drawChart()
  chart6.drawChart()
  chart7.drawChart()
  chart8.drawChart()
  chart9.drawChart()
  knob1.drawChart()
  knob2.drawChart()
  knob3.drawChart()
  spark1.drawChart()
  spark2.drawChart()

reloadChartsEmbargos = ->
  chartDailyEmbargo.drawChart()
  chartMonthlyEmbargo.drawChart()
  chartAnnualEmbargo.drawChart()
  chartStatesEmbargo.drawChart()
  sparkTVAAEmbargo.drawChart()
  sparkTVMAEmbargo.drawChart()
  sparkTVPAEmbargo.drawChart()
  sparkAnnualEmbargo.drawChart()
  sparkMonthlyEmbargo.drawChart()

# selects
selectYears = document.getElementById('yearsSlct')
selectMonths = document.getElementById('monthsSlct')
selectType= document.getElementById('typeSlct')

# charts containers
chartsDeter= document.getElementById('charts-deter')
chartsEmbargo= document.getElementById('charts-embargo')
sparksDeter= document.getElementById('sparks-deter')
sparksEmbargo= document.getElementById('sparks-embargo')
$(chartsEmbargo).hide()
$(sparksEmbargo).hide()

# make those options selected
selectedYear = if H5.Data.thisMonth < 7 then H5.Data.totalPeriods + 1 else H5.Data.totalPeriods
selectYears.options[selectedYear].selected = true
selectMonths.options[H5.Data.thisMonth].selected = true

# SELECTS
$(selectMonths).on "change", (e) ->
  e.preventDefault()
  H5.Data.selectedMonth = parseInt selectMonths.value
  # reload charts
  if H5.Data.selectedType is "embargos"
    reloadChartsEmbargos()
  else if H5.Data.selectedType is 'awifs'
    chart1.drawChart()
    chart2.drawChart()
    chart4.drawChart()
    chart5.drawChart()
    chart6.drawChart()
    chart7.drawChart()
    chart8.drawChart()
  else if H5.Data.selectedType is 'indicar'
    chart1.drawChart()
    chart2.drawChart()
    chart4.drawChart()
    chart7.drawChart()
    chart8.drawChart()
  else
    chart1.drawChart()
    chart3.drawChart()
    chart8.drawChart()
    knob1.drawChart()
    knob2.drawChart()
    knob3.drawChart()
    spark1.drawChart()
    spark2.drawChart()

$(selectYears).on "change", (e) ->
  e.preventDefault()
  H5.Data.selectedYear = parseInt selectYears.value

  # reload charts
  if H5.Data.selectedType is "embargos"
    reloadChartsEmbargos()
  else if H5.Data.selectedType is 'awifs'
    chart1.drawChart()
    chart2.drawChart()
    chart4.drawChart()
    chart5.drawChart()
    chart6.drawChart()
    chart7.drawChart()
    chart8.drawChart()
  else if H5.Data.selectedType is 'indicar'
    chart1.drawChart()
    chart2.drawChart()
    chart4.drawChart()
    chart7.drawChart()
    chart8.drawChart()
  else
    chart1.drawChart()
    chart3.drawChart()
    chart8.drawChart()
    knob1.drawChart()
    knob2.drawChart()
    knob3.drawChart()
    spark1.drawChart()
    spark2.drawChart()

  H5.Data.changed = true

# display only the "amazonia" entries
for region in H5.Data.regions.names
  $("#" + region).hide()
for state in H5.Data.regions.amazonia
  $("#" + state).show()

$(selectType).on "change", (e) ->
  e.preventDefault()
  H5.Data.selectedType = this.value

  if this.value is "deter"

    $("#chart3").show()
    $("#chart5").show()
    $("#chart6").show()

    for region in H5.Data.regions.names
      $("#" + region).hide()
    for state in H5.Data.regions.norte
      $("#" + state).hide()
    for state in H5.Data.regions.sul
      $("#" + state).hide()
    for state in H5.Data.regions.nordeste
      $("#" + state).hide()
    for state in H5.Data.regions.sudeste
      $("#" + state).hide()
    for state in H5.Data.regions.centrooeste
      $("#" + state).hide()

    for state in H5.Data.regions.amazonia
      $("#" + state).show()

    $(chartsEmbargo).hide()
    $(sparksEmbargo).hide()
    $(chartsDeter).show()
    $(sparksDeter).show()
    $("#brasil").addClass "active"
    H5.Data.state = "brasil"
    reloadChartsDeter()

  else if this.value is "embargos"
    for region in H5.Data.regions.names
      $("#" + region).show()
    for state in H5.Data.regions.norte
      $("#" + state).hide()
    for state in H5.Data.regions.sul
      $("#" + state).hide()
    for state in H5.Data.regions.nordeste
      $("#" + state).hide()
    for state in H5.Data.regions.sudeste
      $("#" + state).hide()
    for state in H5.Data.regions.centrooeste
      $("#" + state).hide()
    $("#brasil").show()
    $(chartsDeter).hide()
    $(sparksDeter).hide()
    $(chartsEmbargo).show()
    $(sparksEmbargo).show()
    # reset icons
    for region in H5.Data.regions.names
      $("#" + region).children("i").prop("class", "icon-" + region)
      $("#" + region).removeClass "active"
      $("#brasil").addClass "active"
      H5.Data.state = "brasil"
    reloadChartsEmbargos()

  else if this.value is 'awifs'
    $("#chart3").hide()

    chart1.drawChart()
    chart2.drawChart()
    chart4.drawChart()
    chart5.drawChart()
    chart6.drawChart()
    chart7.drawChart()
    chart8.drawChart()

  else if this.value is 'indicar'
    $("#chart3").hide()
    $("#chart5").hide()
    $("#chart6").hide()

    chart1.drawChart()
    chart2.drawChart()
    chart4.drawChart()
    chart7.drawChart()
    chart8.drawChart()

  H5.Data.selectedType = this.value

# QUICK BTNS
lastSelectedRegion = ""
$("#quick1 a").on "click", (e) ->
  e.preventDefault()

  return if H5.Data.state is this.id

  H5.Data.state = this.id

  # clean all selection
  $(this).each ->
    $("a").removeClass "active"

  if H5.Data.selectedType is "embargos"
    regionToggle = (regions, fastHide) ->
      for region in regions
        if fastHide
          $("#" + region).toggle()
        else
          $("#" + region).fadeToggle(300)

    displayRegion = (region) ->
      regionToggle(H5.Data.regions.names, true)
      regionToggle(region)
      lastSelectedRegion = H5.Data.state
      $("#brasil").hide()

    enableRegion = (region, name) ->
      regionToggle(region, true)
      $("#" + name).addClass "active"
      iconElement = $("#" + name).children("i")
      iconElement.prop("class", "icon-" + H5.Data.state.toLowerCase())
      $("#brasil").show()

    # reset icons
    for region in H5.Data.regions.names
      $("#" + region).children("i").prop("class", "icon-" + region)

    switch H5.Data.state
      when "norte"
        displayRegion(H5.Data.regions.norte)
      when "nordeste"
        displayRegion(H5.Data.regions.nordeste)
      when "sul"
        displayRegion(H5.Data.regions.sul)
      when "sudeste"
        displayRegion(H5.Data.regions.sudeste)
      when "centrooeste"
        displayRegion(H5.Data.regions.centrooeste)
      when "brasil"
        # mark selected option
        $(this).addClass "active"
        reloadChartsEmbargos()
      else
        switch lastSelectedRegion
          when "norte"
            enableRegion(H5.Data.regions.norte, "norte")
          when "nordeste"
            enableRegion(H5.Data.regions.nordeste, "nordeste")
          when "sul"
            enableRegion(H5.Data.regions.sul, "sul")
          when "sudeste"
            enableRegion(H5.Data.regions.sudeste, "sudeste")
          when "centrooeste"
            enableRegion(H5.Data.regions.centrooeste, "centrooeste")
        regionToggle(H5.Data.regions.names)

        reloadChartsEmbargos()
  else
    $(this).addClass "active"
    reloadChartsDeter()

    H5.Data.changed = true
#}}
# # QUICK BTNS 2
# $("#quick3 a").on "click", (event) ->
# # $(".quick-btn a").on "click", (event) ->
#   event.preventDefault()

#   return if H5.Data.state3 is this.id

#   H5.Data.state2 = this.id

#   # clean all selection
#   $(@).each ->
#     $("a").removeClass "active"
#   # mark selected option
#   $(@).addClass "active"

#   # save the selected option
#   H5.Data.state3 = $(@).prop("id")

#   # reload charts
#   reloadChartsNewStats()

#   H5.Data.changed = true


$(document).ready ->
  # chart10.drawChart()
  # chart11.drawChart()
  # chart12.drawChart()
  # chart13.drawChart()
  # BOOTSTRAP
  $("[rel=tooltip]").tooltip placement: "bottom"
  $(".alert").alert()
  # DISPLAY CHARTS AFTER LOADING
  reloadChartsDeter()

  # MISC
  # enable masonry plugin
  $("#charts-content").masonry
    # options
    itemSelector: ".chart"
    animationOptions:
      duration: 1000

  $("#prodes").hide()

  # if charts_content._ratesSlct.value is "0"
  #   $("#ano_prodes").hide()
  #   $("#periodo_deter").show()
  # else
  #   $("#ano_prodes").show()
  #   $("#periodo_deter").hide()

  # if charts_content._shapesSlct.value is "terra_indigena" or charts_content._shapesSlct.value is "floresta"
  #   charts_content._domainSlct.options["0"].selected = true
  #   charts_content._domainSlct.disabled = true
  # else
  #   charts_content._domainSlct.disabled = false

# }}}
