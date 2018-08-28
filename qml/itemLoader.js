
var component;
var sprite;

function createComponentObjects(item, parameters, dest) {
    component = Qt.createComponent("components/"+item);
    if (component.status === Component.Ready)
        finishCreation(parameters,dest);
    else
    {component.statusChanged.connect(finishCreation);
        component.statusChanged(parameters,dest);}
}

function finishCreation(param, dest) {
    if (component.status === Component.Ready) {
        sprite = component.createObject(dest, param);
        if (sprite === null) {
            // Error Handling
            print("Error creating object!");
            console.log("Error creating object");
        }
    } else if (component.status === Component.Error) {
        // Error Handling
        print("Error loading component:", component.errorString());
        console.log("Error loading component:", component.errorString());
    }
}
