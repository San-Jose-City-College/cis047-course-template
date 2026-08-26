// Example: DOM Manipulation and Event Handling

// Get elements from the DOM
const submitBtn = document.querySelector('button[type="submit"]');
const nameInput = document.getElementById('name');

// Add event listener
if (submitBtn) {
    submitBtn.addEventListener('click', function(event) {
        event.preventDefault();
        
        const name = nameInput.value;
        if (name.trim() !== '') {
            console.log('Hello, ' + name + '!');
            alert('Form submitted with name: ' + name);
        } else {
            alert('Please enter a name.');
        }
    });
}

// Example: Function
function calculateSum(a, b) {
    return a + b;
}

console.log('Sum of 5 and 3:', calculateSum(5, 3));
