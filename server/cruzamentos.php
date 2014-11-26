<?php

	include 'config.php';

	$postdata = file_get_contents("php://input");
    $request = json_decode($postdata);

    date_default_timezone_set('America/Sao_Paulo');

    //recebendo variaveis para cruzamento de dados
    $taxa = $request->taxa;
    $inicio = $request->inicio;
    $fim = $request->fim;
    $shape = $request->shape;
    $dominio = $request->dominio;
    $estagio = $request->estagio;
    $uf = $request->uf;

    // Inicialização da variavel que guardará o nome da função a ser consultada no banco.
    $function = "";

    if ($taxa != "PRODES") {
        $date_diff = date_diff(new DateTime($inicio),new DateTime($fim));
    }

    // Array que guardará os dias que serão consultados no banco
    $periodosinicio = [];
    $periodosfim = [];
    $totalMonths = 0;

    $months = ['','Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'];


    if ($taxa != "PRODES") {
        // Se o ultimo dia da consulta for menor que o primeiro dia da consulta, adiciona uma nova iteração
        // para que o problema de calculo de iterações se auto-corrija
        $varFim = new DateTime($fim);
        $var = new DateTime($inicio);
        if ($varFim->format('d') < $var->format('d') || $varFim->format('m') < $var->format('m')) {
            $beginning = 0;
        } else {
            $beginning = 1;
        }


        if($date_diff->days < 50){
            // cria periodos para a consulta sql
            for ($i=1; $i <= $date_diff->days; $i++) {
                array_push($periodosinicio,date_format($var, 'Y-m-d'));
                $var->add(new DateInterval('P1D'));
                array_push($periodosfim,date_format($var, 'Y-m-d'));
            }
        } else if ($date_diff->days < 730) {

            // Para o caso de ter mais de 1 ano, adiciona-se mais 12 meses ao limite da iteração
            if($date_diff->y > 0) {
                $totalMonths = 12 + $date_diff->m;
            } else {
                $totalMonths = $date_diff->m;
            }

            while ($var->format('m') != $varFim->format('m') || $var->format('y') != $varFim->format('y')) {
                array_push($periodosinicio,date_format($var, 'Y-m-d'));
                if($var->format('d') != 1) {
                    $var->setDate($var->format('Y'),$var->format('m'),'1');
                }

                // Seta o periodo de 1 mes para a consulta no banco
                $var->add(new DateInterval('P1M'));

                // Seta o ultimo dia para ser consultado como o ultimo dia do mes
                $var->sub(new DateInterval('P1D'));

                array_push($periodosfim,date_format($var, 'Y-m-d'));

                // Retorna o valor do proximo dia como sendo o valor inicial, o primeiro dia do proximo mes
                $var->add(new DateInterval('P1D'));
            }

            array_push($periodosinicio,date_format($var, 'Y-m-d'));
            array_push($periodosfim,date_format(new DateTime($fim), 'Y-m-d'));

        } else {

            while ($var->format('y') != $varFim->format('y')) {
                array_push($periodosinicio,date_format($var, 'Y-m-d'));
                if($var->format('d') != 1) {
                    $var->setDate($var->format('Y'),'1','1');
                }

                // Seta o periodo de 1 ano para a consulta no banco
                $var->add(new DateInterval('P1Y'));

                // Seta o ultimo dia para ser consultado como o ultimo dia do ano
                $var->sub(new DateInterval('P1D'));

                array_push($periodosfim,date_format($var, 'Y-m-d'));

                // Retorna o valor do proximo dia como sendo o valor inicial, o primeiro dia do proximo ano
                $var->add(new DateInterval('P1D'));
            }

            array_push($periodosinicio,date_format($var, 'Y-m-d'));
            array_push($periodosfim,date_format(new DateTime($fim), 'Y-m-d'));
        }

    } else {
        for ($i=2000; $i < 2014; $i++) {
            array_push($periodosfim,(string) "01-01-" . $i);
        }
    }


    if($taxa ==='DETER'){

        switch ($shape) {
            case 'assentamento':
                $function = 'painel.f_deter_assentamento';
                break;
            case 'terra_indigena':
                $function = 'painel.f_deter_terra_indigena';
                break;
            case 'uc_integral':
                $function = 'painel.f_deter_unidade_protecao_integral';
                break;
            case 'uc_sustentavel':
                $function = 'painel.f_deter_unidade_uso_sustentavel';
                break;
            case 'floresta':
                $function = 'painel.f_deter_floresta_publica';
                break;
            case 'terra_arrecadada':
                $function = 'painel.f_deter_terra_arrecadada';
                break;
        }

    } else if ($taxa == 'AWIFS'){

        switch ($shape) {
            case 'assentamento':
                $function = 'painel.f_awifs_assentamento';
                break;
            case 'terra_indigena':
                $function = 'painel.f_awifs_terra_indigena';
                break;
            case 'uc_integral':
                $function = 'painel.f_awifs_unidade_protecao_integral';
                break;
            case 'uc_sustentavel':
                $function = 'painel.f_awifs_unidade_uso_sustentavel';
                break;
            case 'terra_arrecadada':
                $function = 'painel.f_awifs_terra_arrecadada';
                break;
        }

    } else if ($taxa == 'INDICAR'){

        switch ($shape) {
            case 'assentamento':
                $function = 'painel.f_landsat_assentamento';
                break;
            case 'terra_indigena':
                $function = 'painel.f_landsat_terra_indigena';
                break;
            case 'uc_integral':
                $function = 'painel.f_landsat_unidade_protecao_integral';
                break;
            case 'uc_sustentavel':
                $function = 'painel.f_landsat_unidade_uso_sustentavel';
                break;
            case 'terra_arrecadada':
                $function = 'painel.f_landsat_terra_arrecadada';
                break;
        }

    } else if ($taxa == 'PRODES'){

        switch ($shape) {
            case 'assentamento':
                $function = 'assentamento';
                break;
            case 'terra_indigena':
                $function = 'terra_indigena';
                break;
            case 'uc_integral':
                $function = 'unidades_de_conservacao_protecao_integral';
                break;
            case 'uc_sustentavel':
                $function = 'unidades_de_conservacao_uso_sustentavel';
                break;
            case 'terra_arrecadada':
                $function = 'terra_arrecadada_estadual';
                break;
        }

    }

    $query = "";

    if ($taxa == 'PRODES') {
        $query = "SELECT ";

        if(($shape == "uc_integral" || $shape == "uc_sustentavel" || $shape == "assentamentos" || $shape == "terra_arrecadada") && $dominio == 'ESTADUAL') {
            $function = $function . "_estadual";
        }

        for ($i=0; $i < sizeof($periodosfim); $i++) {
            $array = explode('-', $periodosfim[$i]);
            $query = $query . "( SELECT SUM(" . $function . ") FROM public.dado_prodes_consolidado WHERE ano = '$array[2]' ";
            if ($uf != 'BR') {
                $query = $query . " and uf='$uf' ";
            }
            $query = $query . " ), ";
        }
    } else {
        if (($shape == "terra_arrecadada") && ($dominio == "ESTADUAL")) {
            $function = $function . "_estadual";
        } else if (($shape == "terra_arrecadada") && ($dominio == "FEDERAL")) {
            $function = $function . "_federal";
        }

        if (($taxa == 'INDICAR') || ($taxa == 'AWIFS')) {
            $estagioDB = " '" . $estagio . "', ";
        } else {
            $estagioDB = "";
        }

        if(($shape == "terra_indigena") || ($shape == "terra_arrecadada")){
            $query = "SELECT ";

            for ($i=0; $i < sizeof($periodosinicio); $i++) {
                $query = $query . "( SELECT coalesce(resultado,0) FROM  ". $function ." ( " . $estagioDB . " '$uf' ,'$periodosinicio[$i]','$periodosfim[$i]' ) AS foo (Resultado float)), ";
            }
        }else{
            $query = "SELECT ";

            for ($i=0; $i < sizeof($periodosinicio); $i++) {
                $query = $query . "( SELECT coalesce(resultado,0) FROM  ".$function." ( " . $estagioDB . " '$dominio' , '$uf' ,'$periodosinicio[$i]','$periodosfim[$i]' ) AS foo (Resultado float)), ";
            }
        }
    }

    $query = substr($query, 0, -2);

    $rows = array();
    $table = array();

    $POSTGRES = pg_connect("host=$HOST port=$PORT dbname=$DATABASE user=$USER password=$PASSWORD");

    // echo $query;
    // exit;

	$result = pg_query($query);


    $out = array();

    while($row = pg_fetch_row($result)){
        $out = $row;
    }

    $return = array();

    foreach ($out as $key => $value) {
        $c = array();

        $string = new DateTime($periodosfim[$key]);

        if ($taxa != "PRODES") {
            if ($date_diff->days < 50)
                array_push($c, (object) array(v => $string->format('d/m')));
            else if ($date_diff->days < 730)
                array_push($c, (object) array(v => $months[(int) $string->format('m')]));
            else
                array_push($c, (object) array(v => $string->format('Y')));
        } else {
            array_push($c, (object) array(v => $string->format('Y')));
        }

        array_push($c, (object) array(v => (float) number_format((float)$value, 2, '.', '')));

        // array_push($obj, (object) array(c => $c));
        array_push($return, (object) array(c => $c));
    }

    pg_close($POSTGRES);


    $jsn = json_encode($return);
    print_r($jsn);

    ?>
















