part of cogito_web;

typedef void LeaveCallback();

@Component(
    selector: 'page',
    templateUrl: 'lib/components/page/page.html',
    cssUrl: 'lib/components/page/page.css',
    publishAs: 'cmp'
)
class PageComponent extends ShadowRootAware {
    final width = 1200;
    final height = 675;

    Element paper;
    Element svg;
    ShadowRoot shadowRoot;
    PageService pages;
    ToolController tool;

    Page page = new Page();
    Page savedPage = new Page();

    bool _loaded = false;
    bool dragging = false;
    bool loadingFailed = false;
    bool localFound = false;

    bool allowLeave = false;
    bool unsavedChanges = false;
    bool beforeLeaveModal = false;

    LeaveCallback leaveCallback = () {};

    bool get loaded => _loaded;
    set loaded(bool loaded) {
        _loaded = loaded;

        if (loaded) {
            Timer.run(() {
                if (shadowRoot != null) {
                    paper = shadowRoot.querySelector('rect');
                    svg = shadowRoot.querySelector('svg');
                }
            });
        }
    }

    PageComponent(Element element, RouteProvider routeProvider, Router router, this.pages, this.tool) {
        StreamSubscription onLeaveStream;

        tool.page = this;

        if (pages.haveLocal) {
            localFound = true;
        } else {
            getPage();
        }

        // Deselect the node when the page is clicked
        element.onMouseDown.where((_) => tool.selectedTool == 'select')
                           .listen((Event e) {
                                tool.selectedNode = null;

                                e.preventDefault();
                                e.stopPropagation();
                            });

        window.onBeforeUnload.listen((_) {
            if (!beforeLeaveModal) {
                var message = checkUnsavedChanges();

                if (message != null) {
                    leaveCallback = () => beforeLeaveModal = true;
                }

                return message;
            }
        });
        // routeProvider is null during tests.
        if (routeProvider != null) {
            onLeaveStream = routeProvider.route.onLeave.listen((e) {
                if (checkUnsavedChanges() != null) {
                    e.allowLeave(new Future.value(allowLeave));

                    leaveCallback = () => router.go(e.path, e.parameters);
                }
            });
        }
    }

    /**
     * Creates a new page.
     */
    void newPage() {
        page = new Page();
        loaded = true;
        loadingFailed = false;
    }

    /**
     * Get a [Page] from the server, ignoring the local version
     */
    void getPage() {
        localFound = false;
        pages.getPage().then((page) {
            this.page = page;
            savedPage = page.clone();

            loaded = true;
            loadingFailed = false;
        }).catchError((_) => loadingFailed = true);
    }

    /**
     * Gets the local [Page].
     */
    void getLocalPage() {
        this.page = pages.getLocalPage();
        loaded = true;
    }

    /**
     * Save the page to the server
     */
    save() => pages.savePage(page).then((savedPage) => this.savedPage = savedPage);

    /**
     * Get the point of the [MouseEvent] scaled and moved appropriately to reflect the scaling of the paper
     */
    math.Point getPoint(MouseEvent e) {
        var rect = paper.getBoundingClientRect();

        return new math.Point(e.client.x * width / rect.width - rect.left * width / rect.width,
                              e.client.y * height / rect.height - rect.top * height / rect.height);
    }

    /**
     * Move a node one step closer to the user
     */
    void raise(Node node) {
        var i = page.nodes.indexOf(node);

        if (i < page.nodes.length - 1 && i >= 0) {
            var first = page.nodes.removeAt(i);
            var second = page.nodes.removeAt(i);
            page.nodes.insert(i, first);
            page.nodes.insert(i, second);
        }
    }

    /**
     * Move a node one step away from the user
     */
    void lower(Node node) {
        var i = page.nodes.indexOf(node) - 1;

        if (i >= 0) {
            var first = page.nodes.removeAt(i);
            var second = page.nodes.removeAt(i);
            page.nodes.insert(i, first);
            page.nodes.insert(i, second);
        }
    }

    /**
     * Deletes a node
     */
    void delete(Node node) => page.nodes.remove(node);

    /**
     * Initiates moving/dragging mode
     */
    void move(Node node, math.Point offset) {
        tool.selectedNode = node;

        dragging = true;

        var events = [];

        events.add(svg.parent.onMouseMove.listen((MouseEvent e) {
            var point = getPoint(e);

            node.x = point.x + offset.x;
            node.y = point.y + offset.y;

            e.preventDefault();
            e.stopPropagation();
        }));

        events.add(svg.parent.onMouseUp.listen((Event e) {
            events.forEach((e) => e.cancel());

            dragging = false;

            e.preventDefault();
            e.stopPropagation();
        }));
    }

    /**
     * Check if the page have unsaved changes, and if it does displays a modal
     *
     * Returns 'You have unsaved changes! if there are, null otherwise.
     */
    checkUnsavedChanges([_]) {
        try {
            if (JSON.encode(page.toJson()) != JSON.encode(savedPage.toJson())) {
                pages.saveLocalPage(page);
                unsavedChanges = true;
                return 'You have unsaved changes!';
            }
        } catch (e) {
            return e;
        }
    }

    /**
     * Hides the model and calls leaveCallback
     */
    void leave() {
        allowLeave = true;
        unsavedChanges = false;
        leaveCallback();
    }

    /**
     * Hides the model and clears leaveCallback
     */
    void stay() {
        allowLeave = false;
        unsavedChanges = false;
        leaveCallback = () {};
    }

    void onShadowRoot(ShadowRoot shadowRoot) {
        this.shadowRoot = shadowRoot;
        if (loaded) {
            paper = shadowRoot.querySelector('rect');
            svg = shadowRoot.querySelector('svg');
        }
    }
}
