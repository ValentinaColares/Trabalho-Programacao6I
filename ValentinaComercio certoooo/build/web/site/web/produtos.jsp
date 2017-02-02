<%@include file="cabecalho.jsp" %> 

<%
    Produto obj = new Produto();
    //Plista = pDAO.listar();
    if(request.getParameter("marca")!= null){
        Plista = pDAO.listarFiltro(Integer.parseInt(request.getParameter("marca")), "M");
    }
    else{
        
        if(request.getParameter("categoria")!= null){
            Plista = pDAO.listarFiltro(Integer.parseInt(request.getParameter("categoria")), "C");
        }
        else{
            Plista = pDAO.listar();
        }
    }


%>

<div class="product-model">	 
<div class="container">
        <h2>Produtos</h2>			
         <div class="col-md-9 product-model-sec">
            <!--Começa aqui -->
         <%
            for(Produto Pitem : Plista){
         %>
        <a href="detalhe.jsp?codigo=<%=Pitem.getCodigo()%>"><div class="product-grid">
                <div class="more-product"><span> </span></div>						
                <div class="product-img b-link-stripe b-animate-go  thickbox">
                        <img src="../../Fotos/<%=Pitem.getImagem1() %>"  class="img-responsive" alt="">
                        <div class="b-wrapper">
                        <h4 class="b-animate b-from-left  b-delay03">							
                            <button> + </button> 
                            
                            
                            
                        </h4>
                        </div>
                </div>
        </a>					
                <div class="product-info simpleCart_shelfItem">
                        <div class="product-info-cust prt_name">
                                <h4><%=Pitem.getTitulo() %></h4>								
                                <span class="item_price"><%=Pitem.getPreco() %></span>
                                <div class="ofr">
                                  
                          <p class="disc"></p>
                                </div>
                                <input type="text" class="item_quantity" value="<%Pitem.getQuant(); %>" />
                                <input type="button" class="item_add items" value="+">
                                <div class="clearfix"> </div>
                        </div>												
                </div>
        </div>
            <% } %>
                                     <!-- Acaba aqui -->
 
                        			 
      </div>
        </div>
</div>
 
</div>
-->
<%@include file="rodape.jsp" %> 
