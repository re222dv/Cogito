part of cogito;

@NgComponent(
    selector: 'page',
    templateUrl: '../lib/src/components/page/page.html',
    cssUrl: '../lib/src/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent {
    Page page;
    
    PageComponent() {
        page = new Page();
        
        page.nodes.add(new Text()..color='red'..text='Hello, World!'..x=50..y=50..size=20);
        page.nodes.add(new Text()..color='green'..text='Test'..x=160..y=160..size=50);
    }
}