part of cogito_web;

@Component(
    selector: 'page',
    templateUrl: 'lib/components/page/page.html',
    cssUrl: 'lib/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent {
    Page page;
    PageService pages;

    PageComponent(Element element, ToolController tool, this.pages) {

        page = new Page();

        tool.page = this;

        pages.getPage().then((page) => this.page = page);
    }

    save() => pages.savePage(page);
}
