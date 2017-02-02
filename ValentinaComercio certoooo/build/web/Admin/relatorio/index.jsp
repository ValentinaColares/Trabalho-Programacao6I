<%@page import="modelo.ItemCarrinho"%>
<%@page import="modelo.Carrinho"%>
<%@page import="dao.ItemvendaDAO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="modelo.Itemvenda"%>
<%@page import="modelo.Venda"%>
<%@page import="java.util.List"%>
<%@page import="dao.VendaDAO"%>
<%@include file="../cabecalho.jsp" %>

<% 
    
    VendaDAO Vendadao = new VendaDAO();
    ItemvendaDAO itemVdao = new ItemvendaDAO();
    List<Venda> lista = new ArrayList();
    List<Itemvenda> itemVendalista = new ArrayList();
    Venda venda = new Venda();
    Carrinho carrinho = new Carrinho();
    
    if (request.getParameter("txtFiltro") != null) {
        lista = Vendadao.listar(request.getParameter("txtFiltro"));
        
    } else{ 
    
        //verifico se é excluir
        /* if(request.getParameter("codigo") != null){
            Venda codigo = Vendadao.buscarPorChavePrimaria(Integer.parseInt(request.getParameter("codigo")));
            if(codigo != null){
                 Vendadao.excluir(codigo);
            }
        } */
        
        lista = Vendadao.listar();
     
        itemVendalista = itemVdao.listar();
    }
    
    
    
    

%>

<div class="row">
    <div class="col-lg-12">
        <h1 class="page-header">
            Relatório de Vendas

        </h1>
        <ol class="breadcrumb">
            <li>
                <i class="fa fa-dashboard"></i>  <a href="index.jsp">Listagem</a>
            </li>
            <li class="active">
                <i class="fa fa-file"></i> listagem de vendas
            </li>
        </ol>
    </div>
</div>
<!-- /.row -->

<!-- /.row -->
<div class="row">
    <div class="panel panel-default">
        <form action="#" method="post">
            <div class="form-group input-group">
                <input type="text" class="form-control" name="txtFiltro" placeholder="digite...">
                                <span class="input-group-btn"><button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button></span>
                            </div>
        </form>
        <div class="panel-body">
           
        
        <div class="table-responsive">
            <table class="table table-bordered table-hover">
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Código do Cliente</th>
                        <th>Data da Venda</th>
                        <th>Produtos</th>
                        <th>Valor da Venda</th>
                        
                    </tr>
                </thead>
                <tbody>
                    <%
                        
                        
                        for(Venda item: lista)
                    {
                    %>
                    <tr>
                        <td><%=venda.getCodigo() %></td>
                        <td><%= venda.getCodcliente()%></td>
                        <td><%=venda.getDatavenda() %></td>
                        
                        
                        <td><table class="table table-bordered table-hover">
                            <tr>    
                                <th>Título do Produto</th>
                                <th>Preço do Produto</th>
                                <th>Quantidade</th>
                            </tr>
                            <% 
                                        venda = Vendadao.buscarPorChavePrimaria(item.getCodigo());

                                for(Itemvenda itemVenda: venda.getItemvendaList() ){ %>
                            
                            <tr>
                                <td><%=itemVenda.getProduto().getTitulo() %></td>
                                <td><%=itemVenda.getProduto().getPreco() %></td>
                                <td><%=itemVenda.getQuant()%></td> 
                            </tr>
                            <%} %>
                        </table></td>
            
                        <td><%=venda.getTotal() %></td>
                        
                       </tr>
                    <% } %>
                </tbody>
            </table>
           
                <!-- /.table-responsive -->
            </div>

        </div>
        <!-- /.panel-body -->
    </div>
    <!-- /.panel -->
        </div>
                
                
<%@include file="../modalExcluir.jsp" %>
<%@include file="../rodape.jsp" %>

