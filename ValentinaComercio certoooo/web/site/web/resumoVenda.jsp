<%@page import="java.math.BigDecimal"%>
<%@page import="util.EnviarEmail"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.Titulo"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.Agencia"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.Carteira"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.NumeroDaConta"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.ContaBancaria"%>
<%@page import="org.jrimum.bopepo.BancosSuportados"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.SacadorAvalista"%>
<%@page import="org.jrimum.domkee.comum.pessoa.endereco.CEP"%>
<%@page import="org.jrimum.domkee.comum.pessoa.endereco.UnidadeFederativa"%>
<%@page import="org.jrimum.domkee.comum.pessoa.endereco.Endereco"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.Sacado"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.Cedente"%>
<%@page import="java.io.File"%>
<%@page import="org.jrimum.bopepo.view.BoletoViewer"%>
<%@page import="java.io.OutputStream"%>
<%@page import="org.jrimum.bopepo.Boleto"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.Titulo.EnumAceite"%>
<%@page import="org.jrimum.domkee.financeiro.banco.febraban.TipoDeTitulo"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.sql.Date"%>
<%@page import="dao.VendaDAO"%>
<%@page import="modelo.Venda"%>
<%@page import="modelo.ItemvendaPK"%>
<%@page import="modelo.Itemvenda"%>
<%@page import="dao.ItemvendaDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="modelo.Produto"%>
<%@page import="modelo.ItemCarrinho"%>
<%@page import="dao.ProdutoDAO"%>
<%@page import="modelo.Carrinho"%>
<%@include file="cabecalho.jsp"%>
<%
    Cliente cliente;
    Carrinho carrinho = null;

    if (session.getAttribute("cliente") == null) {
        response.sendRedirect("login.jsp");
    } else {
        cliente = ((Cliente) session.getAttribute("cliente"));

        

        if (session.getAttribute("carrinho") == null) {
            response.sendRedirect("index.jsp");
        } else {
            carrinho = (Carrinho) session.getAttribute("carrinho");
        }

        if (request.getParameter("compra") != null && request.getParameter("compra").equals("true")) {

            Venda venda = new Venda();
            VendaDAO vendadao = new VendaDAO();

            //Set venda total
            venda.setCodcliente(cliente.getCodigo());
            venda.setDatavenda(Date.valueOf(LocalDate.now()));
            venda.setTotal(carrinho.valorTotal());
            venda.setCodstatus(1);
            vendadao.incluir(venda);

            //Set venda de cada produto
            ItemvendaDAO itemvendadao = new ItemvendaDAO();

            for (ItemCarrinho item : carrinho.getListaCarrinho()) {

                Itemvenda itemVenda = new Itemvenda();

                itemVenda.setItemvendaPK(new ItemvendaPK(venda.getCodigo(), item.getProduto().getCodigo()));

                itemVenda.setProduto(item.getProduto());
                itemVenda.setQuant(item.getQuantidade());
                itemVenda.setPreco(item.getProduto().getPreco().doubleValue());
                itemVenda.setVenda(venda);

                itemvendadao.incluir(itemVenda);
            }
            

            /*
                 * INFORMANDO DADOS SOBRE O CEDENTE.
             */
            Cedente cedente = new Cedente("Lojas CRUD", "00.000.208/0001-00");

            /*
                 * INFORMANDO DADOS SOBRE O SACADO.
             */
            Sacado sacado = new Sacado( cliente.getNome(), "222.222.222-22");

            // Informando o endereço do sacado.
            Endereco enderecoSac = new Endereco();
            enderecoSac.setUF(UnidadeFederativa.DESCONHECIDO);
            enderecoSac.setLocalidade(cliente.getCidade());
            enderecoSac.setCep(new CEP(cliente.getCep()));
            enderecoSac.setBairro(cliente.getBairro());
            enderecoSac.setLogradouro(cliente.getEndereco());
            enderecoSac.setNumero("0");
            sacado.addEndereco(enderecoSac);
            

            /*
                 * INFORMANDO DADOS SOBRE O SACADOR AVALISTA.
             */
            SacadorAvalista sacadorAvalista = new SacadorAvalista("Lojas CRUD", "00.000.000/0001-91");

            // Informando o endereço do sacador avalista.
            Endereco enderecoSacAval = new Endereco();
            enderecoSacAval.setUF(UnidadeFederativa.RS);
            enderecoSacAval.setLocalidade("Bagé");
            enderecoSacAval.setCep(new CEP("96405-610"));
            enderecoSacAval.setBairro("Grande Centro");
            enderecoSacAval.setLogradouro("Rua das Amoreiras");
            enderecoSacAval.setNumero("1020");
            sacadorAvalista.addEndereco(enderecoSacAval);


            /*
                 * INFORMANDO OS DADOS SOBRE O TÍTULO.
             */
            // Informando dados sobre a conta bancária do título.
            ContaBancaria contaBancaria = new ContaBancaria(BancosSuportados.BANCO_BRADESCO.create());
            contaBancaria.setNumeroDaConta(new NumeroDaConta(123456, "0"));
            contaBancaria.setCarteira(new Carteira(30));
            contaBancaria.setAgencia(new Agencia(1234, "1"));

            Titulo titulo = new Titulo(contaBancaria, sacado, cedente, sacadorAvalista);
            titulo.setNumeroDoDocumento("123456");
            titulo.setNossoNumero("99345678912");
            titulo.setDigitoDoNossoNumero("5");
            titulo.setValor(BigDecimal.valueOf(carrinho.valorTotal()));
            titulo.setDataDoDocumento(Date.valueOf(LocalDate.now()));
            titulo.setDataDoVencimento(Date.valueOf(LocalDate.now()));
            titulo.setTipoDeDocumento(TipoDeTitulo.DM_DUPLICATA_MERCANTIL);
            titulo.setAceite(EnumAceite.A);
            titulo.setDesconto(new BigDecimal(0.05));
            titulo.setDeducao(BigDecimal.ZERO);
            titulo.setMora(BigDecimal.ZERO);
            titulo.setAcrecimo(BigDecimal.ZERO);
            titulo.setValorCobrado(BigDecimal.ZERO);

            /*
                 * INFORMANDO OS DADOS SOBRE O BOLETO.
             */
            Boleto boleto = new Boleto(titulo);

            boleto.setLocalPagamento("Pagável preferencialmente na Rede X ou em "
                    + "qualquer Banco até o Vencimento.");
            boleto.setInstrucaoAoSacado("Senhor sacado, sabemos sim que o valor "
                    + "cobrado não é o esperado, aproveite o DESCONTÃO!");
            boleto.setInstrucao1("PARA PAGAMENTO 1 até Hoje não cobrar nada!");
            boleto.setInstrucao2("PARA PAGAMENTO 2 até Amanhã Não cobre!");
            boleto.setInstrucao3("PARA PAGAMENTO 3 até Depois de amanhã, OK, não cobre.");
            boleto.setInstrucao4("PARA PAGAMENTO 4 até 04/xx/xxxx de 4 dias atrás COBRAR O VALOR DE: R$ 01,00");
            boleto.setInstrucao5("PARA PAGAMENTO 5 até 05/xx/xxxx COBRAR O VALOR DE: R$ 02,00");
            boleto.setInstrucao6("PARA PAGAMENTO 6 até 06/xx/xxxx COBRAR O VALOR DE: R$ 03,00");
            boleto.setInstrucao7("PARA PAGAMENTO 7 até xx/xx/xxxx COBRAR O VALOR QUE VOCÊ QUISER!");
            boleto.setInstrucao8("APÓS o Vencimento, Pagável Somente na Rede X.");

            /*
                 * GERANDO O BOLETO BANCÁRIO.
             */
            // Instanciando um objeto "BoletoViewer", classe responsável pela
            // geração do boleto bancário.
            BoletoViewer boletoViewer = new BoletoViewer(boleto);

            session.setAttribute("boleto", boletoViewer);
            

            if (request.getMethod().equals("POST")) {
                EnviarEmail enviar = new EnviarEmail();
                enviar.setEmailDestinatario("Seu email"); //cliente.getEmail()
                enviar.setAssunto("Contato - Lojas CRUD");
                //uso StringBuffer para otimizar a concatenação 
                //de string
                StringBuffer texto = new StringBuffer();
                texto.append("<h2 align='center'>Lojas CRUD</h2>");
                texto.append("Informações Enviadas:<br/>");
                texto.append("Software: AAAAA");

                enviar.setMsg(texto.toString());

                boolean enviou = enviar.enviarGmail();

            }

        %><table class="table table-bordered table-hover">
            <tr>
                <th>Compra finalizada com sucesso</th>
                <th>Clique para obter o <a href="boleto.jsp">Boleto</a></th>
             <%
            
            session.setAttribute("carrinho", null);

            %>
            </tr>

        </table>
            
            
            <%
            
        }

%>


<h2 class="venda">Verifique se seu dados estão corretos e finalize a compra</h2> </br>


    <%
    if (carrinho.getListaCarrinho()!= null) {
        for (ItemCarrinho item : carrinho.getListaCarrinho()) {
            Double certo = (item.getProduto().getPreco().doubleValue() * item.getQuantidade());
    %>
    <table class="table table-bordered table-hover">

                <!--<p>Nome: <=item.getProduto().getTitulo()%> </p>
        <p>Quantidade: <=item.getQuantidade()%></p>
        <p>Preço do Produto: $<=item.getProduto().getPreco()%></p>
        <p>Preço total: $<=certo%></p>
        <p>Descrição : <=item.getProduto().getDescricao()%></p> -->
        
        <tr>
            <th>Nome:</th>
            <th>Quantidade:</th>
            <th>Preço do Produto: </th>
            <th>Preço total: </th>
            <th>Descrição: </th>
            <th>Imagem:</th>
        </tr>
        
        <tr>
            <th><%=item.getProduto().getTitulo()%></th>
            <th><%=item.getQuantidade()%></th>
            <th>$<%=item.getProduto().getPreco()%></th>
            <th>$<%=certo%></th>
            <th><%=item.getProduto().getDescricao()%></th>
            <th><img src="../../Fotos/<%=item.getProduto().getImagem1()%>" width="150" height="150" class="img-responsive" alt=""/></th>
        </tr>

    </table>
    <%
        }
    }
    %>


    <h1 class="continue">Preço total da compra: $<%=carrinho.valorTotal()%></h1> </br>

    <table class="table table-bordered table-hover">
        <tr>
            <th>Nome:</th>
            <th><%=cliente.getNome()%></th>
        </tr>
        <tr>
            <th>Endereço:</th>
            <th><%=cliente.getEndereco()%>, <%=cliente.getBairro()%>, <%=cliente.getCidade()%>, <%=cliente.getEstado()%>, <%=cliente.getCep()%></th>
        </tr>
    </table>

    <%if(request.getParameter("compra") == null){ %>
        <a class="order" href="resumoVenda.jsp?compra=true">Finalizar a compra</a>
    <%}else if(request.getParameter("compra") != null){ %>
        <a class="order" href="index.jsp">Finalizar a compra</a>
    <%} %>

<%
    }

%>


<%@include file="rodape.jsp"%>

