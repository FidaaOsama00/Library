#!/bin/bash

# Constants
BOOKS_FILE="books.txt"
BORROW_FILE="borrow.txt"

# Functions
search_books() {
echo "   "
echo -n "Enter the book title: "
read book_title
if [ "$book_title" = "done" ]; then
return
fi

grep -i "Title: $book_title" $BOOKS_FILE
if [ $? -ne 0 ]; then
echo "Book not found. Please try again."
search_books
fi
}

buy_books() {
echo "   "
total_price=0
echo "Enter the book titles you want to buy (Type 'done' when you are finished):"
while true; do
echo -n "Book title: "
read book_title
if [ "$book_title" = "done" ]; then

break
fi

book_info=$(grep -i "Title: $book_title" $BOOKS_FILE)
if [ -z "$book_info" ]; then
echo "Book '$book_title' not found. Please try again."
continue
fi

price=$(echo $book_info | sed -E 's/.*Price: ([0-9.]+).*/\1/')
echo "Price: $price"
total_price=$((total_price + $(printf $price)))
done

echo "Total price: $total_price"
}

borrow_book() {
echo "   "
echo -n "Enter the book title you want to borrow: "
read book_title

book_info=$(grep -i "Title: $book_title" $BOOKS_FILE)

if [ -z "$book_info" ]; then
echo "Book '$book_title' not found. Please try again."
borrow_book
else
echo "$book_info" >> $BORROW_FILE
echo "Do you want to add another book? (yes/no)"
read answer
if [ "$answer" = "yes" ]; then
borrow_book
else
echo "Operation accomplished successfully."
fi
fi
}

return_book() {
echo "   "
echo -n "Enter the book title you want to return: "
read book_title

book_info=$(grep -i "Title: $book_title" $BORROW_FILE)
if [ -z "$book_info" ]; then
echo "Book '$book_title' not found in the borrowed list. Please try again."
return_book
else
sed -i "/$book_info/d" $BORROW_FILE
echo "Operation accomplished successfully."
fi
}

add_book() {
echo "Add a new book:"
read -p "Title: " title
read -p "Price: " price
   
if grep -q -F "Title: $title, Price: $price" "$BOOKS_FILE"; then
   echo "The book already exists in the library."
else
   echo "Title: $title, Price: $price" >> "$BOOKS_FILE"
   echo "Book added successfully!"
fi    
}

list_books() {
echo "Book list:"
echo "-------------------------"
cat "$BOOKS_FILE"
echo "-------------------------"  
}

search_book() {
read -p "Enter the title to search for: " search_title
if awk -v t="$search_title" 'tolower($0) ~ tolower(t) { found=1; print; } END { if (!found) print "The book is not found in the library." }' "$BOOKS_FILE"; then
    :
fi
}

delete_book() {
read -p "Enter the title to delete: " delete_title
if grep -qi "Title: $delete_title" "$BOOKS_FILE"; then
    grep -vi "Title: $delete_title" "$BOOKS_FILE" > temp.txt
    mv temp.txt "$BOOKS_FILE"
    echo "Book deleted successfully!"
else
    echo "The book is not found in the library."
fi   
}

# Reader
display_reader_menu() {
echo "   "
echo "Choose an operation"
echo "a. Search"
echo "b. Buy book"
echo "c. Borrow book"
echo "d. Return book"
echo "e. Exit"
echo -n "Enter your choice: "
read reader_choice
case $reader_choice in
a)
search_books
;;
b)
buy_books
;;
c)
borrow_book
;;
d)
return_book
;;
e)
exit
;;
*)
echo "Invalid choice. Try again..."
;;
esac
}

display_libraryStaff_menu() {
echo ""
echo "1. Add a new book"
echo "2. List all books"
echo "3. Search for a book"
echo "4. Delete a book"
echo "5. Exit"
read -p "Enter the number of the desired operation: " libraryStaff_choice

case $libraryStaff_choice in
      1)
         add_book
         ;;
      2)
         list_books
         ;;
      3)
         search_book
         ;;
      4)
         delete_book
         ;;
      5)
         echo "Thank you for using the library management system!"
         exit 0
         ;;
      *)
         echo "Invalid operation number. Please try again."
         ;;
esac
}

# Main program
echo "Welcome to the Library Management System!"
echo "1. Reader"
echo "2. Library Staff"
echo -n "Enter your choice: "
read choice
case $choice in 

1) 
display_reader_menu
;;

# Library Staff
2)
read -s -p "Please enter the password: " password
if [ "$password" = "1234" ]; then
   while true; do
       display_libraryStaff_menu
       done
else
   echo "Incorrect password. Access denied."
   exit 1
fi
;;
*)
echo "Invalid choice. Exiting..."
exit
;;
esac
