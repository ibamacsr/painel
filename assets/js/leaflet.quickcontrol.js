// Generated by CoffeeScript 1.6.3
(function() {
  var _ref, _ref1, _ref2,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  L.Control.Quickcontrol = (function(_super) {
    __extends(Quickcontrol, _super);

    function Quickcontrol() {
      _ref = Quickcontrol.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Quickcontrol.prototype.options = {
      collapsed: true,
      position: "topright",
      autoZIndex: true
    };

    Quickcontrol.prototype.initialize = function(baseLayers, overlayers, options) {
      L.Util.setOptions(this, options);
      this._layers = {};
      this._lastZIndex = 0;
      return this._handlingClick = false;
    };

    Quickcontrol.prototype.onAdd = function(map) {
      this._initLayout();
      this._update();
      map.on("layeradd", this._onLayerChange, this).on("layerremove", this._onLayerChange, this);
      return this._container;
    };

    Quickcontrol.prototype.onRemove = function(map) {
      return map.off("layeradd", this._onLayerChange).off("layerremove", this._onLayerChange);
    };

    Quickcontrol.prototype.addBaseLayer = function(layer, name) {
      this._addLayer(layer, name);
      this._update();
      return this;
    };

    Quickcontrol.prototype.removeLayer = function(layer) {
      var id;
      id = L.stamp(layer);
      delete this._layers[id];
      this._update();
      return this;
    };

    Quickcontrol.prototype._initLayout = function() {
      var className, container, form, link;
      className = this._className = "switch-control-layers";
      container = this._container = L.DomUtil.create("div", "leaflet-bar " + className);
      this._container.setAttribute('aria-haspopup', true);
      if (!L.Browser.touch) {
        L.DomEvent.disableClickPropagation(this._container);
        L.DomEvent.on(this._container, "mousewheel", L.DomEvent.stopPropagation);
      } else {
        L.DomEvent.on(this._container, "click", L.DomEvent.stopPropagation);
      }
      if (this.options.collapsed) {
        L.DomEvent.on(this._container, "click", this._expand, this);
        link = this._link = L.DomUtil.create("a", className + "-toggle", this._container);
        link.href = "#";
        link.title = "Layers";
        L.DomEvent.on(link, "click", L.DomEvent.stop).on(link, "click", this._expand, this);
        this._map.on("click", this._collapse, this);
      } else {
        this._expand();
      }
      form = this._form = L.DomUtil.create("form", className + "-list switch-layer-list", container);
      return $(this._form).attr('id', 'formLabels');
    };

    Quickcontrol.prototype._update = function() {
      var baseLayersPresent, i, obj, overlayersPresent, _results;
      if (!this._container) {
        return;
      }
      baseLayersPresent = false;
      overlayersPresent = false;
      _results = [];
      for (i in this._layers) {
        obj = this._layers[i];
        this._addItem(obj);
        overlayersPresent = this._overlayersPresent = overlayersPresent || obj.overlayer;
        _results.push(baseLayersPresent = this._baseLayersPresent = baseLayersPresent || !obj.overlayer);
      }
      return _results;
    };

    Quickcontrol.prototype._onLayerChange = function(e) {
      var obj, type;
      obj = this._layers[L.stamp(e.layer)];
      if (!obj) {
        return;
      }
      if (!this._handlingClick) {
        this._update();
      }
      type = (obj.overlayer ? (e.type === "layeradd" ? "overlayeradd" : "overlayerremove") : (e.type === "layeradd" ? "baselayerchange" : null));
      if (type) {
        return this._map.fire(type, obj);
      }
    };

    Quickcontrol.prototype._addItem = function(obj) {
      var name;
      obj.container = L.DomUtil.create("div", "control-group", this._layerContainer);
      obj["switch"] = L.DomUtil.create("div", "control-switch btn-group", obj.container);
      obj.label = L.DomUtil.create("label", "control-label", obj.container);
      this._createSwitch(obj);
      if (obj.name.length > 18) {
        name = obj.name.substr(0, 18) + "…";
      } else {
        name = obj.name;
      }
      obj.label.innerHTML = "<span title=\"" + obj.name + "\">" + name + "</span>";
      return obj.container;
    };

    Quickcontrol.prototype._createSwitch = function(obj) {
      var offBtn,
        _this = this;
      this._onBtn = L.DomUtil.create("button", "btn btn-small", obj["switch"]);
      $(this._onBtn).attr("type", "button");
      this._onBtn.innerHTML = '<span style="padding: 6px"></span>';
      offBtn = L.DomUtil.create("button", "btn btn-small btn-danger", obj["switch"]);
      $(offBtn).attr("type", "button");
      offBtn.innerHTML = '<i class="icon-remove" style="padding: 1px 2px 1px 1px"></i>';
      offBtn.disabled = true;
      obj["switch"].on = this._onBtn;
      obj["switch"].off = offBtn;
      this._switchOnClick(obj);
      if (obj.vectorLayer) {
        this._createVectorLayerOptions(obj);
      }
      return setTimeout(function() {
        var checked;
        checked = _this._map.hasLayer(obj.layer);
        if (checked) {
          return _this._switchOn(obj["switch"]);
        }
      }, 1000);
    };

    Quickcontrol.prototype._switchOnClick = function(obj) {
      var _this = this;
      return $(obj["switch"].on).add(obj["switch"].off).on("click", function(e) {
        var i, layer, switchState;
        L.DomEvent.preventDefault(e);
        if (!obj.overlayer) {
          if (L.DomUtil.hasClass(obj["switch"].on, "btn-primary")) {
            return;
          }
          for (i in _this._layers) {
            layer = _this._layers[i];
            if (!layer.overlayer) {
              _this._switchOff(layer["switch"]);
              _this._toggleLayer(switchState, layer);
              if (_this._map.hasLayer(layer.layer)) {
                _this._map.removeLayer(layer.layer);
              }
            }
          }
        }
        _this._switchToggle(obj["switch"]);
        switchState = L.DomUtil.hasClass(obj["switch"].on, "btn-primary");
        return _this._toggleLayer(switchState, obj);
      });
    };

    Quickcontrol.prototype._switchToggle = function(switchBtn) {
      if (L.DomUtil.hasClass(switchBtn.on, "btn-primary")) {
        return this._switchOff(switchBtn);
      } else {
        return this._switchOn(switchBtn);
      }
    };

    Quickcontrol.prototype._switchOn = function(switchBtn) {
      L.DomUtil.removeClass(switchBtn.off, "btn-danger");
      switchBtn.off.innerHTML = '<span style="padding: 6px"></span>';
      L.DomUtil.addClass(switchBtn.on, "btn-primary");
      switchBtn.on.innerHTML = '<i class="icon-ok"></i>';
      switchBtn.on.disabled = true;
      return switchBtn.off.disabled = false;
    };

    Quickcontrol.prototype._switchOff = function(switchBtn) {
      L.DomUtil.removeClass(switchBtn.on, "btn-primary");
      switchBtn.on.innerHTML = '<span style="padding: 6px"></span>';
      L.DomUtil.addClass(switchBtn.off, "btn-danger");
      switchBtn.off.innerHTML = '<i class="icon-remove" style="padding: 1px 2px 1px 1px"></i>';
      switchBtn.on.disabled = false;
      return switchBtn.off.disabled = true;
    };

    Quickcontrol.prototype._createVectorLayerOptions = function(obj) {
      var clusterContainer, clusterInput, clusterLabel, container, data, input, inputRange, key, label, opacityContainer, opacityInput, opacityLabel, options, select, separator, updateQuery, value, _i, _len, _ref1, _ref2, _results,
        _this = this;
      if (obj.vectorLayer.opacity) {
        opacityContainer = L.DomUtil.create("div", "control-vector", obj.container.controlLayer);
        opacityLabel = L.DomUtil.create("label", "", opacityContainer);
        opacityLabel.innerHTML = "Opacidade";
        opacityInput = L.DomUtil.create("input", "input-mini pull-right", opacityContainer);
        $(opacityInput).attr("type", "number");
        $(opacityInput).attr("max", "100");
        $(opacityInput).attr("min", "0");
        $(opacityInput).val("70");
        $(opacityInput).on("change", function() {
          var _this = this;
          return obj.layer.eachLayer(function(layer) {
            if (layer.setOpacity) {
              return layer.Opacity(_this.value / 100);
            } else {
              return layer.setStyle({
                fillOpacity: _this.value / 100,
                opacity: _this.value / 100
              });
            }
          });
        });
      }
      if (obj.vectorLayer.clusters) {
        clusterContainer = L.DomUtil.create("div", "control-vector", obj.container.controlLayer);
        clusterLabel = L.DomUtil.create("label", "", clusterContainer);
        clusterLabel.innerHTML = "Contador";
        clusterInput = L.DomUtil.create("select", "input-small pull-right", clusterContainer);
        options = {
          yes: "Sim",
          no: "Não"
        };
        for (key in options) {
          value = options[key];
          $(clusterInput).append('<option value="' + key + '">' + value + '</option>');
        }
        $(clusterInput).on("change", function(e) {
          if (e.target.value === "yes") {
            return _this._map.addLayer(obj.vectorLayer.clusters.layer);
          } else {
            return _this._map.removeLayer(obj.vectorLayer.clusters.layer);
          }
        });
      }
      if (obj.vectorLayer.filters) {
        L.DomUtil.create('div', 'switch-control-layers-separator', obj.container.controlLayer);
        obj.vectorLayer.inputs = {};
        updateQuery = function() {
          var data, end, filter, input, qry, start, _ref1;
          qry = "";
          _ref1 = obj.vectorLayer.filters;
          for (key in _ref1) {
            data = _ref1[key];
            switch (data.type) {
              case "select" || "input":
                filter = obj.vectorLayer.filters[key];
                input = obj.vectorLayer.inputs[key];
                if (qry) {
                  qry += " AND ";
                }
                if (input.value !== filter.reset) {
                  qry += filter.dbfield + " = '" + input.value + "'";
                }
                break;
              case "period":
                filter = obj.vectorLayer.filters[key];
                input = obj.vectorLayer.inputs[key];
                if (inputRange.start.value && inputRange.end.value) {
                  start = input.start.value.split("/");
                  end = input.end.value.split("/");
                  if (qry) {
                    qry += " AND ";
                  }
                  qry += filter.dbfield + " BETWEEN '" + start[2] + "-" + start[1] + "-" + start[0] + "' AND '" + end[2] + "-" + end[1] + "-" + end[0] + "'";
                }
            }
          }
          obj.vectorLayer.layer.setOptions({
            where: qry
          });
          obj.vectorLayer.layer.redraw();
          if (obj.vectorLayer.clusters) {
            obj.vectorLayer.clusters.setOptions({
              where: qry
            });
            obj.vectorLayer.clusters.redraw();
          }
          return console.log(qry);
        };
        _ref1 = obj.vectorLayer.filters;
        _results = [];
        for (key in _ref1) {
          data = _ref1[key];
          container = L.DomUtil.create("div", "control-vector", obj.container.controlLayer);
          label = L.DomUtil.create("label", "", container);
          label.innerHTML = key;
          switch (data.type) {
            case "select":
              select = L.DomUtil.create("select", "input-small pull-right", container);
              $(select).attr("id", key);
              obj.vectorLayer.inputs[key] = select;
              _ref2 = data.value;
              for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
                value = _ref2[_i];
                $(select).append('<option value="' + value + '">' + value + '</option>');
              }
              _results.push($(select).on("change", function(e) {
                return updateQuery();
              }));
              break;
            case "input":
              input = L.DomUtil.create("input", "input-small pull-right", container);
              obj.vectorLayer.inputs[key] = input;
              $(input).attr("type", "text");
              $(input).attr("placeholder", data.value);
              _results.push($(input).on("change", function(e) {
                var enterKey;
                L.DomEvent.preventDefault(e);
                enterKey = 13;
                if (e.keyCode === enterKey) {
                  return updateQuery();
                }
              }));
              break;
            case "period":
              inputRange = L.DomUtil.create('div', 'input-daterange pull-right', container);
              $(inputRange).attr('id', "switch" + key);
              inputRange.start = L.DomUtil.create('input', 'input-small', inputRange);
              separator = L.DomUtil.create('i', 'icon-caret-right', inputRange);
              inputRange.end = L.DomUtil.create('input', 'input-small', inputRange);
              $(inputRange.start).attr('name', 'start');
              $(inputRange.start).attr('type', 'text');
              $(inputRange.start).attr('id', 'dateStart');
              $(inputRange.start).attr('placeholder', data.placeholder);
              $(separator).css("padding", "0 6px");
              $(separator).css("position", "relative");
              $(separator).css("top", "-4px");
              $(inputRange.end).attr('name', 'end');
              $(inputRange.end).attr('type', 'text');
              $(inputRange.end).attr('id', 'dateEnd');
              $(inputRange.end).attr('placeholder', data.placeholder);
              $(inputRange).datepicker({
                format: "dd/mm/yyyy",
                language: "pt-BR",
                autoclose: true,
                orientation: "auto right",
                clearBtn: true,
                startView: 1,
                startDate: "01/07/2004",
                endDate: "today"
              });
              $(inputRange.start).datepicker('update', '-1y');
              $(inputRange.end).datepicker('update', 'today');
              $(inputRange).on("changeDate", function(e) {
                if (!inputRange.start.value || !inputRange.end.value) {
                  return;
                }
                return updateQuery();
              });
              $(document).click(function(e) {
                if (e.target.id !== "dateStart" && e.target.id !== "dateEnd") {
                  if ($(".datepicker").is(":visible")) {
                    if (!$(e.target).hasClass("day") && !$(e.target).hasClass("month") && !$(e.target).hasClass("year") && !$(e.target).hasClass("datepicker-switch") && !$(e.target).hasClass("prev") && !$(e.target).hasClass("next") && !$(e.target).parents(".datepicker").hasClass("datepicker")) {
                      return $(inputRange.start).add(inputRange.end).datepicker("hide");
                    }
                  }
                }
              });
              _results.push(obj.vectorLayer.inputs[key] = inputRange);
              break;
            default:
              _results.push(void 0);
          }
        }
        return _results;
      }
    };

    Quickcontrol.prototype._toggleLayer = function(switchState, obj) {
      this._handlingClick = true;
      if (switchState && !this._map.hasLayer(obj.layer)) {
        this._map.addLayer(obj.layer);
      } else {
        if (!(switchState && this._map.hasLayer(obj.layer))) {
          this._map.removeLayer(obj.layer);
        }
      }
      return this._handlingClick = false;
    };

    Quickcontrol.prototype._expand = function() {
      return L.DomUtil.addClass(this._form, "switch-control-layers-expanded");
    };

    Quickcontrol.prototype._collapse = function() {
      return this._form.className = this._form.className.replace(" switch-control-layers-expanded", "");
    };

    return Quickcontrol;

  })(L.Control);

  L.Control.Supercontrol = (function(_super) {
    __extends(Supercontrol, _super);

    function Supercontrol() {
      _ref1 = Supercontrol.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    Supercontrol.prototype.initialize = function(baseLayers, overlayers, tabs, options) {
      var _this = this;
      Supercontrol.__super__.initialize.apply(this, arguments);
      if (Object.keys(tabs).length > 0) {
        this._tabs = tabs;
        this.options.enableTabs = true;
      }
      $.each(baseLayers, function(name, obj) {
        return _this._addLayer(obj.layer, name, false, false, null);
      });
      return $.each(overlayers, function(name, obj) {
        return _this._addLayer(obj.layer, name, true, obj.vectorLayer, obj.tab);
      });
    };

    Supercontrol.prototype.addOverLayer = function(layer, name, vectorLayer, tab) {
      this._addLayer(layer, name, true, vectorLayer, tab);
      this._update();
      return this;
    };

    Supercontrol.prototype._initLayout = function() {
      var _this = this;
      Supercontrol.__super__._initLayout.apply(this, arguments);
      this._createTabArea(this._form);
      setTimeout(function() {
        _this._selectedTab = document.getElementById("tabLinkbaselayers");
        return _this._activeTab();
      }, 1000);
      return this._createAddLayer(this._tabsList['upload']);
    };

    Supercontrol.prototype._createAddLayer = function(container) {
      var _this = this;
      this._divContainer = L.DomUtil.create('div', 'divContainer', container);
      this._divFile = L.DomUtil.create('div', '', this._divContainer);
      $(this._divFile).attr('id', 'divBtnFile');
      this._files = [];
      this._btFileLayer = L.DomUtil.create('input', '', this._divFile);
      $(this._btFileLayer).attr('type', 'file');
      $(this._btFileLayer).attr('name', 'files[]');
      $(this._btFileLayer).attr('id', 'btFileLayer');
      $(this._btFileLayer).attr('multiple', '');
      $(this._btFileLayer).on('change', function(event) {
        var _strAux;
        _this._handleFiles(event);
        return _strAux = $('#btFileLayer').val();
      });
      this._btFakeFile = L.DomUtil.create('button', 'btn btnSlide', this._divFile);
      $(this._btFakeFile).attr('type', 'button');
      $(this._btFakeFile).html("Abrir <i class='icon-folder-open'></i>");
      $(this._btFakeFile).on('click', function(event) {
        return $(_this._btFileLayer).trigger('click');
      });
      this._btAddToMap = L.DomUtil.create('button', 'btn btn-primary btnSlide', this._divFile);
      $(this._btAddToMap).attr('type', 'button');
      $(this._btAddToMap).attr('id', 'btAddToMap');
      $(this._btAddToMap).html("Adicionar");
      $(this._btAddToMap).hide();
      this._divFileError = L.DomUtil.create('div', 'divError', this._divContainer);
      $(this._divFileError).attr('id', 'divFileError');
      $(this._divFileError).hide();
      this._divFileAlert = L.DomUtil.create('div', 'divFileContainer', this._divContainer);
      $(this._divFileAlert).attr('id', 'divFileContainer');
      $(this._divFileAlert).html('<div id="nenhuma"><i>Nenhum arquivo selecionado.</i></div>');
      return $(this._btAddToMap).on('click', function(event) {
        _this._createLayer();
        $(_this._divFileError).hide();
        $(_this._divFileAlert).html('<div id="nenhuma"><i>Nenhum arquivo selecionado.</i></div>');
        return $(_this._btAddToMap).hide();
      });
    };

    Supercontrol.prototype._createLayer = function() {
      var f, reader, shape, _extIndex, _i, _len, _ref2, _results, _strExt, _this;
      _ref2 = this._files;
      _results = [];
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        f = _ref2[_i];
        _extIndex = f.name.lastIndexOf('.');
        _strExt = f.name.substring(_extIndex);
        _this = this;
        if (_strExt === '.shp') {
          shape = new Shapefile(f, function(data) {
            var newLayer, track;
            track = L.geoJson(data.geojson).addTo(map);
            newLayer = {
              name: _this._reduceString(data.fileName, 11),
              layer: track,
              overlayControl: true,
              tab: "uploaded",
              overlayer: true,
              deleteControl: true
            };
            return _this._addItem(newLayer);
          });
        } else if (_strExt === '.kml') {
          reader = new FileReader();
          reader.file = f;
          reader.onloadend = function(event) {
            var newLayer, track, _fileContent;
            if (event.target.readyState === FileReader.DONE) {
              _fileContent = event.target.result;
              track = new L.KML(_fileContent, {
                async: true
              });
              newLayer = {
                name: _this._reduceString(this.file.name, 11),
                layer: track,
                overlayControl: true,
                tab: "uploaded",
                overlayer: true,
                deleteControl: true
              };
              return _this._addItem(newLayer);
            }
          };
          reader.readAsText(f);
        } else if (_strExt === '.gpx') {
          reader = new FileReader();
          reader.file = f;
          reader.onloadend = function(event) {
            var newLayer, track, _fileContent;
            if (event.target.readyState === FileReader.DONE) {
              _fileContent = event.target.result;
              track = new L.GPX(_fileContent, {
                async: true
              });
              newLayer = {
                name: _this._reduceString(this.file.name, 11),
                layer: track,
                overlayControl: true,
                tab: "uploaded",
                overlayer: true,
                deleteControl: true
              };
              return _this._addItem(newLayer);
            }
          };
          reader.readAsText(f);
        }
        this._files = [];
        _results.push($(this._divFileAlert).html('<div id="nenhuma"><i>Nenhum arquivo selecionado.</i></div>'));
      }
      return _results;
    };

    Supercontrol.prototype._handleFiles = function(evt) {
      var error, f, _aux, _extIndex, _htmlError, _i, _len, _strExt, _strNameAux, _tempFiles,
        _this = this;
      _tempFiles = evt.target.files;
      error = [];
      _aux = document.getElementById('nenhuma');
      if (_aux !== void 0) {
        $(_aux).remove();
      }
      for (_i = 0, _len = _tempFiles.length; _i < _len; _i++) {
        f = _tempFiles[_i];
        _extIndex = f.name.lastIndexOf('.');
        _strExt = f.name.substring(_extIndex);
        if (_strExt !== '.kml' && _strExt !== '.shp' && _strExt !== '.gpx') {
          _strNameAux = this._reduceString(f.name, 28);
          _htmlError = "<span>     " + _strNameAux + "</span></br>";
          error.push(_htmlError);
          continue;
        }
        this._createFileItem(f, this._divFileAlert);
        this._files.push(f);
      }
      if (error.length > 0) {
        this._divFileError.innerHTML = '<div id="divWarning" class="alert alert-warning alert-block"><a href="#" class="close" data-dismiss="alert">×</a><strong>O(s) Arquivo(s): </strong></br>' + error.join('') + '<strong> não pode(puderam) ser exportado(s).</strong></div>';
        $(this._divFileError).show();
        $('#divWarning > a').on('click', function(event) {
          if (_this._divFileAlert.innerHTML === '') {
            return $(_this._divFileAlert).html('<div id="nenhuma"><i>Nenhum arquivo selecionado.</i></div>');
          }
        });
      } else {
        this._divFileError.innerHTML = '';
        $(this._divFileError).hide();
      }
      if (this._divFileAlert.innerHTML === '') {
        $(this._divFileAlert).html('<div id="nenhuma"><i>Nenhum arquivo selecionado.</i></div>');
      }
      if (this._files.length > 0) {
        return $("#btAddToMap").show();
      } else {
        return $("#btAddToMap").hide();
      }
    };

    Supercontrol.prototype._reduceString = function(string, size) {
      var _nroRemove, _strAux;
      if (string.length <= size) {
        return string;
      }
      _strAux = string;
      _nroRemove = string.length - size;
      _strAux = string.slice(12, _nroRemove + 15);
      string = string.replace(_strAux, "...");
      return string;
    };

    Supercontrol.prototype._createFileItem = function(file, container) {
      var _btnTrash, _btnType, _divTemp, _nameAux, _ulTemp,
        _this = this;
      _divTemp = L.DomUtil.create('div', 'divItem', container);
      _btnType = L.DomUtil.create('button', 'btn pull-left', _divTemp);
      $(_btnType).html('<img src="../dist/img/world.png"></img>');
      _ulTemp = L.DomUtil.create('ul', '', _divTemp);
      _nameAux = this._reduceString(file.name, 28);
      $(_ulTemp).attr('id', file.name);
      $(_ulTemp).html('<strong>' + _nameAux + '</strong>');
      _btnTrash = L.DomUtil.create('button', 'btn pull-right', _divTemp);
      $(_btnTrash).html('<i class="icon-trash"></i>');
      $(_btnTrash).on('click', function(e) {
        var div, divParent, f, fileName, index, _i, _len, _ref2, _ulAux;
        L.DomEvent.preventDefault(e);
        div = e.target.parentNode;
        _ulAux = $(div).children('ul');
        fileName = _ulAux.attr('id');
        console.log(_this._files);
        _ref2 = _this._files;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          f = _ref2[_i];
          if (f.name === fileName) {
            index = _this._files.indexOf(f);
            _this._files.splice(index, 1);
            break;
          }
        }
        console.log(_this._files);
        if (e.target.nodeName === 'I') {
          divParent = e.target.parentNode.parentNode;
        } else {
          divParent = e.target.parentNode;
        }
        $(divParent).remove();
        if ($("#divFileContainer").html() === "") {
          return $("#btAddToMap").hide();
        }
      });
      return _divTemp;
    };

    Supercontrol.prototype._createTabArea = function(container) {
      var obj,
        _this = this;
      this._tabsDiv = L.DomUtil.create('div', 'tabbable tabs-left', container);
      $(this._tabsDiv).attr('id', 'tabsDiv');
      this._divUL = L.DomUtil.create('div', 'divUl', this._tabsDiv);
      $(this._divUL).attr('id', 'divUl');
      this._tabsOverLayers = L.DomUtil.create('ul', 'nav nav-tabs', this._divUL);
      $(this._tabsOverLayers).attr('id', 'tabsOverLayers');
      this._tabsContentOverLayers = L.DomUtil.create('div', 'tab-content', this._tabsDiv);
      $(this._tabsContentOverLayers).attr('id', 'tabsContent');
      this._tabsList = {};
      if (this.options.enableTabs) {
        $.each(this._tabs, function(tab, obj) {
          _this._createTab(tab, obj);
          if (obj.tabs === void 0) {
            return _this.options.miscTabs = true;
          }
        });
      } else {
        obj = {
          icon: "../dist/img/baselayers.png"
        };
        this._createTab('baselayers', obj);
        obj = {
          icon: "../dist/img/overlayers.png"
        };
        this._createTab('overlayers', obj);
      }
      if (this.options.miscTabs) {
        obj = {
          icon: "../dist/img/world.png"
        };
        this._createTab(this.options.miscTabsName, obj);
      }
      obj = {
        icon: "../dist/img/preferences.png"
      };
      this._createTab('uploaded', obj);
      obj = {
        icon: "../dist/img/upload.png"
      };
      return this._createTab('upload', obj);
    };

    Supercontrol.prototype._createTab = function(tab, obj) {
      var newTab, newTabContent, newTabName;
      newTab = L.DomUtil.create('li', '', this._tabsOverLayers);
      newTabContent = L.DomUtil.create('div', 'tab-pane', this._tabsContentOverLayers);
      $(newTabContent).attr('id', tab);
      this._tabsList[tab] = newTabContent;
      newTabName = L.DomUtil.create('a', '', newTab);
      $(newTabName).attr('id', "tabLink" + tab);
      $(newTabName).attr('href', '#' + tab);
      $(newTabName).attr('data-toggle', 'tab');
      if (obj.name) {
        newTabName.innerHTML = obj.name;
      } else {
        newTabName.innerHTML = '<img src=" ' + obj.icon + '" width="22px" height="22px">';
      }
      L.DomEvent.on(newTabName, "click", (function() {
        this._selectedTab = newTabName;
        return this._selectedTabContent = newTabContent;
      }), this);
    };

    Supercontrol.prototype._activeTab = function() {
      return $(this._selectedTab).trigger("click");
    };

    Supercontrol.prototype._addLayer = function(layer, name, overlayer, vectorLayer, tab) {
      var id;
      id = L.stamp(layer);
      this._layers[id] = {
        layer: layer,
        name: name,
        overlayer: overlayer,
        vectorLayer: vectorLayer,
        tab: tab
      };
      if (this.options.autoZIndex && layer.setZIndex) {
        this._lastZIndex++;
        return layer.setZIndex(this._lastZIndex);
      }
    };

    Supercontrol.prototype._update = function() {
      $.each(this._tabsList, function() {
        return $(this).html("");
      });
      Supercontrol.__super__._update.apply(this, arguments);
      return this._createAddLayer(this._tabsList['upload']);
    };

    Supercontrol.prototype._addItem = function(obj) {
      if (obj.overlayer) {
        if (this.options.enableTabs) {
          if (obj.tab) {
            this._layerContainer = this._tabsList[obj.tab];
          } else if (this.options.miscTabs) {
            this._layerContainer = this._tabsList[this.options.miscTabsName];
          }
        } else {
          if (obj.tab === 'uploaded') {
            this._layerContainer = this._tabsList[obj.tab];
          } else {
            this._layerContainer = this._tabsList['overlayers'];
          }
        }
      } else {
        if (this.options.enableTabs) {
          if (obj.tab) {
            this._layerContainer = this._tabsList[obj.tab];
          } else if (this.options.miscTabs) {
            this._layerContainer = this._tabsList['layers'];
          }
        } else {
          this._layerContainer = this._tabsList['baselayers'];
        }
      }
      Supercontrol.__super__._addItem.apply(this, arguments);
      if (obj.deleteControl) {
        this._createDeleteButton(obj);
      }
      if (obj.tab === 'uploaded') {
        return $(this._onBtn).trigger('click');
      }
    };

    Supercontrol.prototype._createVectorLayerOptions = function(obj) {
      var btnCloseControl, controlOptions, divLabel, labelControl,
        _this = this;
      controlOptions = L.DomUtil.create("button", "btn btn-small pull-right", obj.container);
      $(controlOptions).html('<i class="icon-cog"></i>');
      obj.container.controlLayer = L.DomUtil.create("div", "divSlideInOut", obj.container);
      btnCloseControl = L.DomUtil.create("button", 'btnClose', obj.container.controlLayer);
      $(btnCloseControl).html('&times;');
      $(btnCloseControl).on('click', function(e) {
        var div;
        L.DomEvent.preventDefault(e);
        div = e.target.parentNode;
        return $(div).hide('slide', {
          direction: "right"
        }, 400);
      });
      $(obj.container.controlLayer).hide();
      divLabel = L.DomUtil.create("div", "divLabel", obj.container.controlLayer);
      labelControl = L.DomUtil.create("span", '', divLabel);
      $(labelControl).html("<i class='icon-cog'></i>&nbsp;&nbsp;" + obj.name);
      Supercontrol.__super__._createVectorLayerOptions.apply(this, arguments);
      return $(controlOptions).on("click", function(e) {
        L.DomEvent.preventDefault(e);
        return $(obj.container.controlLayer).show('slide', {
          direction: "right"
        }, 400);
      });
    };

    Supercontrol.prototype._createDeleteButton = function(obj) {
      var controlOptions,
        _this = this;
      controlOptions = L.DomUtil.create("button", "btn btn-small pull-right", obj.container);
      $(controlOptions).html('<i class="icon-trash"></i>');
      return $(controlOptions).on('click', function(e) {
        var divParent;
        L.DomEvent.preventDefault(e);
        if (_this._map.hasLayer(obj.layer)) {
          _this._map.removeLayer(obj.layer);
        }
        if (e.target.nodeName === 'I') {
          divParent = e.target.parentNode.parentNode;
        } else {
          divParent = e.target.parentNode;
        }
        return $(divParent).remove();
      });
    };

    return Supercontrol;

  })(L.Control.Quickcontrol);

  L.Control.Cleancontrol = (function(_super) {
    __extends(Cleancontrol, _super);

    function Cleancontrol() {
      _ref2 = Cleancontrol.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    Cleancontrol.prototype.initialize = function(baseLayers, overlayers, options) {
      var _this = this;
      Cleancontrol.__super__.initialize.apply(this, arguments);
      $.each(baseLayers, function(name, obj) {
        return _this._addLayer(obj.layer, name, false, false);
      });
      return $.each(overlayers, function(name, obj) {
        return _this._addLayer(obj.layer, name, true, obj.vectorLayer);
      });
    };

    Cleancontrol.prototype.addOverLayer = function(layer, name, vectorLayer) {
      var _this = this;
      this._addLayer(layer, name, true, vectorLayer);
      this._update();
      return this;
      $.each(baseLayers, function(name, obj) {
        return _this._addLayer(obj.layer, name, false, false);
      });
      return $.each(overlayers, function(name, obj) {
        return _this._addLayer(obj.layer, name, true, obj.vectorLayer);
      });
    };

    Cleancontrol.prototype._initLayout = function() {
      Cleancontrol.__super__._initLayout.apply(this, arguments);
      this._baseLayersList = L.DomUtil.create('div', this._className + '-base', this._form);
      this._separator = L.DomUtil.create('div', this._className + '-separator', this._form);
      return this._overlayersList = L.DomUtil.create('div', this._className + '-overlayers', this._form);
    };

    Cleancontrol.prototype._addLayer = function(layer, name, overlayer, vectorLayer) {
      var id;
      id = L.stamp(layer);
      this._layers[id] = {
        layer: layer,
        name: name,
        overlayer: overlayer,
        vectorLayer: vectorLayer
      };
      if (this.options.autoZIndex && layer.setZIndex) {
        this._lastZIndex++;
        return layer.setZIndex(this._lastZIndex);
      }
    };

    Cleancontrol.prototype._update = function() {
      this._baseLayersList.innerHTML = "";
      this._overlayersList.innerHTML = "";
      Cleancontrol.__super__._update.apply(this, arguments);
      return this._separator.style.display = (this._overlayersPresent && this._baseLayersPresent ? "" : "none");
    };

    Cleancontrol.prototype._addItem = function(obj) {
      if (obj.overlayer) {
        this._layerContainer = this._overlayersList;
      } else {
        this._layerContainer = this._baseLayersList;
      }
      return Cleancontrol.__super__._addItem.apply(this, arguments);
    };

    Cleancontrol.prototype._createVectorLayerOptions = function(obj) {
      var controlLayerOuter, controlOptions,
        _this = this;
      controlOptions = L.DomUtil.create("button", "btn btn-small pull-right", obj.container);
      $(controlOptions).html('<i class="icon-cog"></i>');
      controlLayerOuter = L.DomUtil.create("div", "control-layers", obj.container);
      obj.container.controlLayer = L.DomUtil.create("div", "control-layers-inner", controlLayerOuter);
      Cleancontrol.__super__._createVectorLayerOptions.apply(this, arguments);
      return $(controlOptions).on("click", function(e) {
        L.DomEvent.preventDefault(e);
        if (!$(obj.container.controlLayer).is(':animated')) {
          return $(obj.container.controlLayer).slideToggle(400);
        }
      });
    };

    return Cleancontrol;

  })(L.Control.Quickcontrol);

}).call(this);
