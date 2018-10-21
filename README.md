# flutter_course Notes

Notes taken from the course
-----

## Misc

How to use regexp, (Chek if a number in string): RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)

Please note that our validation right now only accepts dots (. ) as a decimal separator. This regex pattern could look like this to also allow for commas:

RegExp(r'^(?:[1-9]\d*|0)?(?:[.,]\d+)?$') 

The submission of the form would fail then though since a value like 9,99  can't be parsed into a double. Since this is a valid decimal number in Europe, we should be able to handle this of course. 

Hence you want to ensure that when saving the value, you're swapping any commas for dots: 

_formData['price'] = double.parse(value.replaceFirst(RegExp(r','), '.')) 


For email address validation, you can use this RegEx: 

RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")

## Forms
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

The validator should **return nothing** if the validation is successful.

TextFormField(
        decoration: InputDecoration(labelText: 'Product Title'),
        validator: (String value) {
          // if (value.trim().length <= 0) {
          if (value.isEmpty) {
            return 'Title is required';
          }          
        },
        onSaved: (String value) {
          setState(() {
            _titleValue = value;
          });
        });
  }

## Focus

Taking focus priority over a textinput will close the keyboard for example.

GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode()); // FocusNode() is just an empty node.
      },

## Layout

Getting the device width; final double deviceWidth = MediaQuery.of(context).size.width;

Align Vertically -- mainAxisAlignment: MainAxisAlignment.center
Align Horizontally -- crossAxisAlignment: CrossAxisAlignment.center

#### Using Objects (Map)

Map works like Map<KeyType, ValueType>

Map<String, dynamic> for multiple types

#### OTher stuff
ButtonBar -- Add multiple buttons side by side

Container -- Can set height manually

Expanded -- Sort of like container but takes up the rest of the screen height. (Dynamic)

ListView.builder -- Best way to render unknown sized list - Loads when needed, destroys when out of screen.

Listview always take the full availanble space left on screen.

#### Touch Events

Wrap any element in a GestureDetector

GestureDetector(
  onTap: _submitForm,
  child: Container(
      color: Colors.green,
      padding: EdgeInsets.all(5.0),
      child: Text('MyButton')),
)


##### Navigation

- Hamburger menu is called **drawer**. drawer is for left side and drawerend is right side.

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              title: Text('Choose'),
            ),
            ListTile(
              title: Text('Manage Products'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('EasyList'),
      ),
      body: ProductManager(),
    );
  }
}

-----

## Tabs

> The Pages returned from the Tabview does not need its own scaffold since they are only sub-pages.

  Widget build(BuildContext context) {
    appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                text: 'Create Product',
                icon: Icon(Icons.create),
              ),
              Tab(text: 'My Products', icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductCreatePage(), ProductListPage()],
        ),
      ),
    );
  }

  -----

  ## Named Routes
  
> Create the registry in main.dart

'/' is a Special route that serves as home route.

-       routes: {
        '/': (BuildContext context) => ProductsPage(),
        '/admin': (BuildContext context) => ProductsAdminPage(),
      },

> Navigate to it by pushNamed or pushReplacementNamed
- Navigator.pushNamed(context, '/admin');


>- ### Named routes is probably preffere over below solutions.
- Navigate to with back navigation -> Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ProductPage()))
- Navigate to without possibility to back -> Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ProductsPage()))
- Navigate back -> Navigator.pop(context)


>**Listen for The Result Of The Navigation**

> return WillPopScope(onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false); // Allows to leave page.
      },
      child: Scaffold(..)
    }
  )
  
- This will listen for clicks on the back button.

> Navigator.push<returntype>(.....)**.then((Type returnedValue) = {
  .. Execute stuff.
}

### Unknown route // 404 page? (main.dart)

onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => ProductsPage(_products, _addProduct, _deleteProduct)
        );
      },

# Rendering Lists


- Column tries to squeeze all elements onto one page.

- Use ListView to render a scrollable list.

- ListView must be wrappet into a fixed-height container or Expandable Widget if
it's not the only Widget on the screen!

- Use ListView(children: ...) for short lists where you know the amount of items in advance (example; user input forms)



# Rendering Conditional Content

- Use ternary expressions to render different widgets ( return  x == 0 ? "it was true" : "it was false")

- Do not return null, use empty Container() instead.

- Use if-statements instead of ternary for more complex conditions or widget trees

### Code Below will render a **LARGE** list in the most performant way - Loading when needed and destroying when scrolling out of picture.

``` 
 Products([this.products = const []]) {
    print('[Products Widget] Constructor');
  }

  Widget _buildProductItem(BuildContext context, int index) {
    return Card(
        child: Column(
          children: <Widget>[
            Image.asset('assets/food.jpg'),
            Text(products[index])
          ],
        ),
      );

  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ListView.builder(
      itemBuilder: _buildProductItem,
      itemCount: products.length
    );
  }
  ```


### Conditional Rendering

## To not render nothing, simply return an Empty Container().


#### With turnary for simpler cases
```   
@override
  Widget build(BuildContext context) {
    return products.length > 0 ? ListView.builder(
      itemBuilder: _buildProductItem,
      itemCount: products.length,
    ) : Center(child: Text('No products found, please add some'),);
  }
```
  
#### For more Complex Cases
```
@override
  Widget build(BuildContext context) {
    Widget productCard = Center(child: Text('No products found, please add some'),);
    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }
    return productCard;
 ```   

 #### Third way would be to move it out to functions.

```
   Widget _buildProductLists() {
    Widget productCard = Center(child: Text('No products found, please add some'),);

    if (products.length > 0) {
      productCard = ListView.builder(
        itemBuilder: _buildProductItem,
        itemCount: products.length,
      );
    }

    return productCard;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return _buildProductLists();
  }
```