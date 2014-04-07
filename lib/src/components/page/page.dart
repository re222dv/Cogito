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

        page.texts.add(new Text()..color='red'..text='Hello, World!'..x=50..y=50..size=20);
        page.texts.add(new Text()..color='green'..text='Test'..x=160..y=160..size=50);

        page.paths.add(new Path()..color='blue'..path='M 55 22 L 272 99'..width=20..x=50..y=50);
    }
}
